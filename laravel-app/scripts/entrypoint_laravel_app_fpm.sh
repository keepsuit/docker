#!/bin/sh

if [ $# -ne 0 ]; then
	$@
	exit 0;
fi

set -e

/scripts/runtime_cache.sh

ln -s /etc/services-available/nginx /etc/services.d/nginx
ln -s /etc/services-available/php-fpm /etc/services.d/php-fpm
ln -s /etc/nginx/sites-available/php-fpm.conf /etc/nginx/sites-enabled/default.conf

/init