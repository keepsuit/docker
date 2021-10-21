#!/bin/sh

cd /app

php artisan config:cache -n || true
php artisan route:cache -n || true
php artisan view:cache -n || true
php artisan lighthouse:cache -n || true