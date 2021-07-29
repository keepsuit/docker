FROM twentyweb/cms-base:8.0

RUN install-php-extensions swoole grpc protobuf

RUN apk add --no-cache mysql-client \
  nginx \
  nginx-mod-http-xslt-filter \
  nginx-mod-http-geoip \
  tzdata \
  curl \
  ca-certificates

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=048b95b48b708983effb2e5c935a1ef8483d9e3e

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

RUN GRPC_HEALTH_PROBE_VERSION=v0.4.4 && \
    wget -qO/usr/local/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /usr/local/bin/grpc_health_probe

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN rm -rf /etc/nginx/conf.d/*
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d /etc/nginx/conf.d
COPY nginx/sites-available /etc/nginx/sites-available

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
  && rm /usr/local/etc/php-fpm.d/zz-docker.conf
COPY php/conf.d $PHP_INI_DIR/conf.d

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

RUN rm -rf /var/cache/apk/* && \
        rm -rf /tmp/*

COPY services.d /etc/services-available
COPY scripts /scripts

RUN mkdir -p /etc/services.d \
    && mkdir -p /etc/nginx/sites-enabled \
    && mkdir -p /etc/supercronic \
    && chmod +x /scripts/* \
    && echo '* * * * * cd /app && php artisan schedule:run >> /dev/null 2>&1' > /etc/supercronic/crontab

EXPOSE 80

ENTRYPOINT ["/scripts/entrypoint_laravel_app_fpm.sh"]
CMD []

