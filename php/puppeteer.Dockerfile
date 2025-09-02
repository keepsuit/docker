ARG IMAGE_TAG=8.4-fpm-debian
FROM keepsuit/php:${IMAGE_TAG}

USER root

RUN docker-php-serversideup-install-puppeteer

USER www-data
