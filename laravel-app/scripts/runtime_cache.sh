#!/bin/sh

cd /app

php artisan config:cache -n -q || true
php artisan route:cache -n -q || true
php artisan view:cache -n -q || true
php artisan lighthouse:cache -n -q || true