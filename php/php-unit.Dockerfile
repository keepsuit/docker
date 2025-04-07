# syntax=docker/dockerfile:1

ARG PHP_VERSION=8.3
ARG IMAGE_VERSION=v3.5.2
ARG SUPERCRONIC_VERSION=v0.2.33

FROM serversideup/php:${PHP_VERSION}-unit-${IMAGE_VERSION}

USER root

RUN install-php-extensions \
    bcmath \
    excimer \
    exif \
    ffi \
    ftp \
    gd \
    gettext \
    gmp \
    iconv \
    intl \
    openswoole \
    pdo_sqlite \
    phar \
    posix \
    protobuf \
    redis \
    simplexml \
    soap \
    sockets \
    sodium \
    sqlite3 \
    xsl \
    uv

RUN docker-php-serversideup-dep-install-debian "ffmpeg default-mysql-client"

RUN ln -s $(php-config --extension-dir) /usr/local/lib/php/extensions/current

ARG PHP_VERSION
ARG TARGETARCH
RUN curl -sSL -o grpc.so "https://s3.eu-central-1.amazonaws.com/docker-php-assets.keepsuit.com/extensions/${PHP_VERSION}/bookworm/${TARGETARCH}/grpc.so" \
    && mv grpc.so /usr/local/lib/php/extensions/current/grpc.so \
    && docker-php-ext-enable grpc

ARG SUPERCRONIC_VERSION
ARG TARGETARCH
RUN curl -sSL -o supercronic "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-${TARGETARCH}" \
    && chmod +x supercronic \
    && mv supercronic /usr/local/bin/supercronic

COPY --chmod=755 common/ /

USER www-data
WORKDIR /app
ENV APP_BASE_DIR=/app
ENV UNIT_WEBROOT=/app/public
ENV AUTORUN_ENABLED=true
ENV AUTORUN_LARAVEL_MIGRATION=false
ENV AUTORUN_LARAVEL_CONFIG_CACHE=false
ENV AUTORUN_LARAVEL_EVENT_CACHE=false
ENV AUTORUN_LARAVEL_ROUTE_CACHE=false
ENV AUTORUN_LARAVEL_VIEW_CACHE=false
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_MAX_EXECUTION_TIME=900
ENV PHP_MEMORY_LIMIT=512M
ENV PHP_POST_MAX_SIZE=256M
ENV PHP_UPLOAD_MAX_FILESIZE=256M
