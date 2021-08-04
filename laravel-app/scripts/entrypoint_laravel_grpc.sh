#!/bin/sh

if [ $# -ne 0 ]; then
  $@
  exit 0
fi

set -e

cd /app

HOST=${HOST:-}
PORT=${PORT:-9090}

if [ -n "$WATCH" ]; then
  php artisan grpc:start --host=$HOST --port=$PORT --watch -n
else
  /scripts/runtime_cache.sh
  php artisan grpc:start --host=$HOST --port=$PORT -n
fi
