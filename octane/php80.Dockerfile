FROM twentyweb/cms-base:8.0

RUN install-php-extensions swoole

RUN apk add --no-cache mysql-client \
  nginx \
  nginx-mod-http-xslt-filter \
  nginx-mod-http-geoip \
  tzdata \
  curl \
  ca-certificates

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN rm -rf /etc/nginx/conf.d/*
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/sites-enabled/

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
  && rm /usr/local/etc/php-fpm.d/zz-docker.conf
COPY php/conf.d $PHP_INI_DIR/conf.d/

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

RUN rm -rf /var/cache/apk/* && \
        rm -rf /tmp/*

COPY services.d /etc/services.d
COPY scripts /scripts

RUN chmod +x /scripts/*

EXPOSE 80

ENTRYPOINT ["/scripts/entrypoint_laravel_app.sh"]
CMD []

