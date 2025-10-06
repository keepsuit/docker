ARG IMAGE_TAG=8.4-fpm-debian
FROM keepsuit/php:${IMAGE_TAG}

USER root

RUN docker-php-serversideup-install-puppeteer
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

USER www-data
