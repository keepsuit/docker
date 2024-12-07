# syntax=docker/dockerfile:1

ARG IMAGE_VERSION=v3.5.1
FROM serversideup/php:8.3-unit-${IMAGE_VERSION}

USER root

RUN install-php-extensions \
    bcmath \
    exif \
    ftp \
    gd \
    gettext \
    gmp \
    iconv \
    intl \
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
    xsl

RUN docker-php-serversideup-dep-install-debian "ffmpeg default-mysql-client"

RUN ln -s $(php-config --extension-dir) /usr/local/lib/php/extensions/current
ARG TARGETARCH
COPY extensions/8.3/bookworm/${TARGETARCH}/ /usr/local/lib/php/extensions/current/
RUN docker-php-ext-enable grpc

COPY --chmod=755 common/ /

USER www-data
WORKDIR /app
ENV APP_BASE_DIR=/app
ENV UNIT_WEBROOT=/app/public
ENV AUTORUN_ENABLED=true
ENV AUTORUN_LARAVEL_MIGRATION=false
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_MAX_EXECUTION_TIME=900
ENV PHP_MEMORY_LIMIT=512M
ENV PHP_POST_MAX_SIZE=256M
ENV PHP_UPLOAD_MAX_FILESIZE=256M
