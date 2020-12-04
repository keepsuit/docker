#!/bin/sh

mkdir -p storage/app/public && \
mkdir -p storage/backups && \
mkdir -p storage/framework/cache && \
mkdir -p storage/framework/sessions && \
mkdir -p storage/framework/views && \
mkdir -p storage/logs

php artisan package:discover

chown -R www-data:www-data . \
&& chmod ug+wx -R storage bootstrap
