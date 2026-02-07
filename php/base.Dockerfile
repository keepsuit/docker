# syntax=docker/dockerfile:1

ARG PHP_VERSION=8.4
ARG IMAGE_VERSION=v4.3.1
# Use 'debian' or 'alpine'
ARG OS=debian
# Use 'fpm' or 'frankenphp'
ARG VARIANT=fpm
ARG SUPERCRONIC_VERSION=v0.2.42

FROM serversideup/php:${PHP_VERSION}-fpm-nginx-${OS}-${IMAGE_VERSION} AS base_fpm
FROM serversideup/php:${PHP_VERSION}-frankenphp-${OS}-${IMAGE_VERSION} AS base_frankenphp

FROM base_${VARIANT}

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
    imagick \
    intl \
    pdo_sqlite \
    phar \
    posix \
    protobuf \
    simplexml \
    soap \
    sockets \
    sodium \
    sqlite3 \
    xsl \
    uv

RUN ln -s $(php-config --extension-dir) /usr/local/lib/php/extensions/current

# Don't install recommended packages to keep image size down
RUN sed -i 's/apt-get install -y \$DEP_PACKAGES/apt-get install -y --no-install-recommends \$DEP_PACKAGES/g' /usr/local/bin/docker-php-serversideup-dep-install-debian

# Remove directory serving from nginx config
ARG VARIANT
RUN if [ "$VARIANT" = "fpm" ]; then \
        sed -i 's/try_files \$uri \$uri\//try_files $uri /' /etc/nginx/site-opts.d/http.conf.template; \
        sed -i 's/try_files \$uri \$uri\//try_files $uri /' /etc/nginx/site-opts.d/https.conf.template; \
    fi

COPY --chmod=755 common/ /

ARG TARGETARCH
ARG PHP_VERSION
ARG OS
ARG SUPERCRONIC_VERSION
RUN docker-php-serversideup-setup

USER www-data
WORKDIR /app
ENV APP_BASE_DIR=/app
ENV CADDY_SERVER_ROOT=/app/public
ENV NGINX_WEBROOT=/app/public
ENV AUTORUN_ENABLED=true
ENV AUTORUN_LARAVEL_MIGRATION=false
ENV AUTORUN_LARAVEL_OPTIMIZE=true
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_JIT=on
ENV PHP_OPCACHE_JIT_BUFFER_SIZE=100M
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0
ENV PHP_OPCACHE_INTERNED_STRINGS_BUFFER=16
ENV PHP_MAX_EXECUTION_TIME=55
ENV PHP_MEMORY_LIMIT=512M
ENV PHP_POST_MAX_SIZE=256M
ENV PHP_UPLOAD_MAX_FILESIZE=256M
