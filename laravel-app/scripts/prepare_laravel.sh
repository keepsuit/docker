#!/bin/sh

# Fix: telescope requires cache connection on registration
export TELESCOPE_ENABLED=false

mkdir -p storage/app/public && \
mkdir -p storage/backups && \
mkdir -p storage/framework/cache && \
mkdir -p storage/framework/sessions && \
mkdir -p storage/framework/views && \
mkdir -p storage/logs

chown -R www-data:www-data . \
&& chmod ug+wx -R storage bootstrap

php artisan package:discover