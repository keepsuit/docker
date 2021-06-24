#!/bin/sh

cd /app

php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true