#!/bin/sh
# Expose the private metrics listener on port 8081, but only for Laravel apps:
# the endpoint boots the framework to read the queue depth.

[ -f "${APP_BASE_DIR:-/app}/artisan" ] || exit 0

if command -v nginx >/dev/null 2>&1; then
	cp /usr/local/share/metrics/nginx.conf /etc/nginx/conf.d/metrics.conf
elif [ -f /etc/frankenphp/Caddyfile ]; then
	cp /usr/local/share/metrics/metrics.caddyfile /etc/frankenphp/caddyfile.d/metrics.caddyfile
fi
