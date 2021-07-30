#!/bin/sh

if [ $# -ne 0 ]; then
	$@
	exit 0;
fi

set -e

/scripts/runtime_cache.sh

cd /app

HOST=${HOST:-}
PORT=${PORT:-9090}

php artisan grpc:start --host=$HOST --port=$PORT -n