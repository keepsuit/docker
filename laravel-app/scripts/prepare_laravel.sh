#!/bin/sh

# Fixes
# - telescope requires cache connection on registration
# - docker set OTEL_TRACES_EXPORTER in build context
export TELESCOPE_ENABLED=false
export OTEL_TRACES_EXPORTER=null

mkdir -p storage/app/public && \
mkdir -p storage/backups && \
mkdir -p storage/framework/cache && \
mkdir -p storage/framework/sessions && \
mkdir -p storage/framework/views && \
mkdir -p storage/logs

chown -R www-data:www-data . \
&& chmod ug+wx -R storage bootstrap

php artisan package:discover
