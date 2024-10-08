#!/bin/sh

if [ -f "$APP_BASE_DIR/artisan" ]; then
    echo "Preparing Laravel application..."

    cd $APP_BASE_DIR

    mkdir -p storage/app/public
    mkdir -p storage/backups
    mkdir -p storage/framework/cache
    mkdir -p storage/framework/sessions
    mkdir -p storage/framework/views
    mkdir -p storage/logs

    chmod ug+wx -R storage bootstrap

    php artisan package:discover
fi
