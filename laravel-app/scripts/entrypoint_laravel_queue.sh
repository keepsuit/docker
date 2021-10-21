#!/bin/sh

if [ $# -ne 0 ]; then
	$@
	exit 0;
fi

set -e

/scripts/runtime_cache.sh

cd /app

CONNECTION=${CONNECTION:-}
NAME=${NAME:-default}
QUEUE=${QUEUE:-default}
TRIES=${TRIES:-1}
TIMEOUT=${TIMEOUT:-90}
MAX_JOBS=${MAX_JOBS:-0}
MAX_TIME=${MAX_TIME:-0}

if [ -n "$WATCH" ]; then
  php artisan queue:listen --verbose --name=$NAME --queue=$QUEUE --tries=$TRIES --timeout=$TIMEOUT --max-jobs=$MAX_JOBS --max-time=$MAX_TIME $CONNECTION
else
  php artisan queue:work --verbose --name=$NAME --queue=$QUEUE --tries=$TRIES --timeout=$TIMEOUT --max-jobs=$MAX_JOBS --max-time=$MAX_TIME $CONNECTION
fi