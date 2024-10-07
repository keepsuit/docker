# syntax=docker/dockerfile:1

ARG IMAGE_VERSION=v3.4.0-beta1
FROM serversideup/php:8.3-fpm-nginx-alpine-${IMAGE_VERSION}

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
    redis \
    simplexml \
    soap \
    sockets \
    sodium \
    sqlite3 \
    xsl

RUN docker-php-serversideup-dep-install-alpine "ffmpeg mysql-client"

RUN sed -i 's/exit 0/return 0/g' /etc/entrypoint.d/10-init-webserver-config.sh

COPY --chmod=755 common/ /

USER www-data
WORKDIR /app
ENV APP_BASE_DIR=/app
ENV NGINX_WEBROOT=/app/public
ENV AUTORUN_ENABLED=true
ENV AUTORUN_LARAVEL_MIGRATION=false
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_MAX_EXECUTION_TIME=900
ENV PHP_MEMORY_LIMIT=512M
ENV PHP_POST_MAX_SIZE=256M
ENV PHP_UPLOAD_MAX_FILESIZE=256M
