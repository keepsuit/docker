#!/bin/sh

if [ $# -ne 0 ]; then
	$@
	exit 0;
fi

set -e

/scripts/runtime_cache.sh

cd /app

while [ true ]
do
  php artisan schedule:run --verbose --no-interaction &
  sleep 60
done