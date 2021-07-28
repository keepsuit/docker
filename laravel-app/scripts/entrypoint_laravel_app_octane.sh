#!/bin/sh

if [ $# -ne 0 ]; then
	$@
	exit 0;
fi

set -e

/scripts/runtime_cache.sh

ln -s /etc/services-available/nginx /etc/services.d/nginx
ln -s /etc/services-available/octane /etc/services.d/octane
ln -s /etc/nginx/sites-available/octane.conf /etc/nginx/sites-enabled/default.conf

/init