FROM twentyweb/cms-base:8.2 as php-extensions
ENV PHP_PROTOBUF_VERSION=3.21.6
ENV PHP_GRPC_VERSION=1.49.0
RUN install-php-extensions protobuf-${PHP_PROTOBUF_VERSION} grpc-${PHP_GRPC_VERSION} \
    && mkdir -p /out \
    && cp $(php-config --extension-dir)/grpc.so /out/grpc.so \
    && cp $(php-config --extension-dir)/protobuf.so /out/protobuf.so


FROM twentyweb/cms-base:8.2

ARG TARGETARCH

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
COPY nginx/conf.d /etc/nginx/conf.d
COPY nginx/sites-available /etc/nginx/sites-available

COPY --from=php-extensions /out/*.so /tmp/extensions/
RUN mv /tmp/extensions/*.so $(php-config --extension-dir)/ \
  && docker-php-ext-enable protobuf grpc

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && rm /usr/local/etc/php-fpm.d/zz-docker.conf
COPY php/conf.d $PHP_INI_DIR/conf.d

ENV SUPERCRONIC_VERSION=v0.2.1
RUN curl -sSL -o supercronic "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-${TARGETARCH}" \
    && chmod +x supercronic \
    && mv supercronic /usr/local/bin/supercronic

ENV GRPC_HEALTH_PROBE_VERSION=v0.4.14
RUN curl -sSL -o grpc_health_probe "https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-${TARGETARCH}" \
    && chmod +x grpc_health_probe \
    && mv grpc_health_probe /usr/local/bin/grpc_health_probe

ENV S6_OVERLAY_VERSION=v2.2.0.3
RUN case ${TARGETARCH} in \
    "amd64")  S6_OVERLAY_ARCH=amd64  ;; \
    "arm64")  S6_OVERLAY_ARCH=aarch64  ;; \
    esac \
    && curl -sSL -o s6-overlay-installer "https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}-installer" \
    && chmod +x s6-overlay-installer \
    && ./s6-overlay-installer / \
    && rm -rf ./s6-overlay-installer

COPY services.d /etc/services-available
COPY scripts /scripts

RUN mkdir -p /etc/services.d \
    && mkdir -p /etc/nginx/sites-enabled \
    && mkdir -p /etc/supercronic \
    && chmod +x /scripts/* \
    && ln -s /scripts/entrypoint_laravel_app_fpm.sh /scripts/entrypoint_laravel_app.sh \
    && echo '* * * * * cd /app && php artisan schedule:run' > /etc/supercronic/crontab

EXPOSE 80

ENTRYPOINT ["/scripts/entrypoint_laravel_app_fpm.sh"]
CMD []

