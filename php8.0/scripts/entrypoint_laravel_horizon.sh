#!/bin/sh

if [ $# -ne 0 ]; then
	$@
	exit 0;
fi

set -e

cd /app

php artisan horizon