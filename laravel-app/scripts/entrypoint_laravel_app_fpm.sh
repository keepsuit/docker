#!/bin/sh

if [ $# -ne 0 ]; then
	$@
	exit 0;
fi

set -e

/scripts/runtime_cache.sh

ln -s /etc/service-available/nginx /etc/services.d/nginx
ln -s /etc/service-available/php-fpm /etc/services.d/php-fpm
ln -s /etc/nginx/sites-enabled/php-fpm.conf /etc/nginx/sites-available/default.conf

/init