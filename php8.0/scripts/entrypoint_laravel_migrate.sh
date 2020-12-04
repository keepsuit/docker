#!/bin/sh

set -e

cd /app

php artisan migrate --verbose --no-interaction --force
