# syntax=docker/dockerfile:1

ARG PHP_VERSION=8.4
ARG IMAGE_VERSION=v5.0.0
# Use 'debian' or 'alpine'
ARG OS=debian
# Use 'fpm' or 'frankenphp'
ARG VARIANT=fpm
ARG SUPERCRONIC_VERSION=v0.2.49
ARG PIE_VERSION=1.5.2

FROM serversideup/php:${PHP_VERSION}-fpm-nginx-${OS}-${IMAGE_VERSION} AS base_fpm
FROM serversideup/php:${PHP_VERSION}-frankenphp-${OS}-${IMAGE_VERSION} AS base_frankenphp

FROM base_${VARIANT}

USER root

RUN install-php-extensions \
    bcmath \
    calendar \
    exif \
    ffi \
    ftp \
    gd \
    gettext \
    gmp \
    imagick \
    intl \
    opentelemetry \
    protobuf \
    soap \
    sockets \
    sqlite3 \
    xsl \
    uv

ARG PIE_VERSION
RUN curl -fL https://github.com/php/pie/releases/download/${PIE_VERSION}/pie.phar -o /usr/local/bin/pie \
    && chmod +x /usr/local/bin/pie \
    && pie -V

RUN ln -s $(php-config --extension-dir) /usr/local/lib/php/extensions/current

# Don't install recommended packages to keep image size down
RUN sed -i 's/install -y /install -y --no-install-recommends /' /usr/local/bin/docker-php-serversideup-dep-install-debian

# Remove directory serving from nginx config
ARG VARIANT
RUN if [ "$VARIANT" = "fpm" ]; then \
    sed -i 's/try_files \$uri \$uri\//try_files $uri /' /etc/nginx/site-opts.d/http.conf.template; \
    sed -i 's/try_files \$uri \$uri\//try_files $uri /' /etc/nginx/site-opts.d/https.conf.template; \
    fi

COPY --chmod=755 common/ /

# opcache.file_cache needs the directory to exist and be writable
RUN mkdir -p /var/cache/opcache && chown www-data:www-data /var/cache/opcache

# The entrypoint installs the metrics listener config as www-data at runtime.
# The nginx variants already chown /etc/nginx, the frankenphp one doesn't.
RUN if [ -d /etc/frankenphp/caddyfile.d ]; then chown www-data:www-data /etc/frankenphp/caddyfile.d; fi

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
ENV PHP_OPCACHE_ENABLE=1
# ENV PHP_OPCACHE_JIT=on
ENV PHP_OPCACHE_JIT_BUFFER_SIZE=32M
ENV PHP_MAX_EXECUTION_TIME=55
ENV PHP_MEMORY_LIMIT=512M
ENV PHP_POST_MAX_SIZE=256M
ENV PHP_UPLOAD_MAX_FILESIZE=256M
