# syntax=docker/dockerfile:1

FROM twentyweb/cms-base:8.3 as php-extensions
ARG TARGETPLATFORM

RUN apk add --no-cache \
    autoconf \
    gcc \
    g++ \
    libstdc++ \
    linux-headers \
    make \
    musl-dev \
    php83-dev \
    php83-pear \
    zlib-dev

ARG PROTOBUF_VERSION=3.25.1
ARG GRPC_VERSION=1.60.0
RUN pecl83 install protobuf-$PROTOBUF_VERSION \
    && pecl83 install grpc-$GRPC_VERSION

RUN mkdir -p /out \
    && cp $(php-config83 --extension-dir)/protobuf.so /out/protobuf.so \
    && cp $(php-config83 --extension-dir)/grpc.so /out/grpc.so


FROM twentyweb/cms-base:8.3
ARG TARGETARCH

RUN apk add --no-cache mysql-client \
#    php83-pecl-grpc \
#    php83-pecl-protobuf \
    php83-pecl-opentelemetry \
    unit \
    unit-php83 \
    tzdata \
    curl \
    ca-certificates

RUN ln -s $(php -r 'echo ini_get("extension_dir");') /usr/lib/extensions

COPY --from=php-extensions /out/*.so /usr/lib/extensions
RUN echo "extension=protobuf.so" > /etc/php/8.3/mods-available/protobuf.ini && phpenmod protobuf \
    && echo "extension=grpc.so" > /etc/php/8.3/mods-available/grpc.ini && phpenmod grpc

COPY unit/conf.json /var/lib/unit/conf.json

ADD https://raw.githubusercontent.com/php/php-src/PHP-8.3/php.ini-production /etc/php83/php.ini
COPY php/conf.d /etc/php83/conf.d/

ENV SUPERCRONIC_VERSION=v0.2.28
RUN curl -sSL -o supercronic "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-${TARGETARCH}" \
    && chmod +x supercronic \
    && mv supercronic /usr/local/bin/supercronic

ENV GRPC_HEALTH_PROBE_VERSION=v0.4.23
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
    && mkdir -p /etc/supercronic \
    && chmod +x /scripts/* \
    && rm -rf /scripts/entrypoint_laravel_app_fpm.sh \
    && ln -s /scripts/entrypoint_laravel_app_unit.sh /scripts/entrypoint_laravel_app.sh \
    && echo '* * * * * cd /app && php artisan schedule:run' > /etc/supercronic/crontab

EXPOSE 80

ENTRYPOINT ["/scripts/entrypoint_laravel_app_unit.sh"]
CMD []

