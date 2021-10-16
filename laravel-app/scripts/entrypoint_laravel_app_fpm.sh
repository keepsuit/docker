#!/bin/sh

if [ $# -ne 0 ]; then
	$@
	exit 0;
fi

set -e

/scripts/reset_services.sh

ln -sf /etc/services-available/nginx /etc/services.d/nginx
ln -sf /etc/services-available/php-fpm /etc/services.d/php-fpm
ln -sf /etc/nginx/sites-available/php-fpm.conf /etc/nginx/sites-enabled/default.conf

/init