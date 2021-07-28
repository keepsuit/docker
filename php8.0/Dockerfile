FROM php:8.0-fpm-alpine3.12

WORKDIR /app

RUN apk update && apk add --no-cache mysql-client

ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions \
    && install-php-extensions \
        bcmath \
        exif \
        gettext \
        gmp \
        intl \
        mysqli \
        opcache \
        pcntl \
        pdo_mysql \
        swoole \
        redis \
        zip
#        gd
#        imagick
#        soap

COPY conf.d $PHP_INI_DIR/conf.d/
COPY php-fpm.d /usr/local/etc/php-fpm.d
COPY scripts /scripts

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && chmod +x /scripts/*