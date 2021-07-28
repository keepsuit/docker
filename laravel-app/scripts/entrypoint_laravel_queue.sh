#!/bin/sh

if [ $# -ne 0 ]; then
	$@
	exit 0;
fi

set -e

/scripts/runtime_cache.sh

cd /app

NAME=${NAME:-default}
QUEUE=${QUEUE:-default}
TRIES=${TRIES:-1}
TIMEOUT=${TIMEOUT:-90}

php artisan queue:work --verbose --name=$NAME --queue=$QUEUE --tries=$TRIES --timeout=$TIMEOUT