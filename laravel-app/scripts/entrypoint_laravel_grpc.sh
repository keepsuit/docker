#!/bin/sh

if [ $# -ne 0 ]; then
  $@
  exit 0
fi

set -e

cd /app

HOST=${HOST:-}
PORT=${PORT:-9090}
WORKERS=${WORKERS:-auto}

if [ -n "$WATCH" ]; then
  php artisan grpc:start --host=$HOST --port=$PORT --workers=1 --watch -n
else
  /scripts/runtime_cache.sh
  php artisan grpc:start --host=$HOST --port=$PORT --workers=$WORKERS -n
fi
