#!/bin/sh

if [ $# -ne 0 ]; then
	$@
	exit 0;
fi

set -e


cd /app

CONNECTION=${CONNECTION:-}
NAME=${NAME:-}
QUEUE=${QUEUE:-}
TRIES=${TRIES:-1}
TIMEOUT=${TIMEOUT:-90}
MAX_JOBS=${MAX_JOBS:-0}
MAX_TIME=${MAX_TIME:-0}

if [ "$WATCH" == "true" ]; then
  php artisan queue:listen -v -n --name=$NAME --queue=$QUEUE --tries=$TRIES --timeout=$TIMEOUT $CONNECTION
else
  /scripts/runtime_cache.sh
  php artisan queue:work -v -n --name=$NAME --queue=$QUEUE --tries=$TRIES --timeout=$TIMEOUT --max-jobs=$MAX_JOBS --max-time=$MAX_TIME $CONNECTION
fi