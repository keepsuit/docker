#!/bin/sh
# Populate the opcache file cache once per container.

if [ -f "$APP_BASE_DIR/artisan" ] && [ -w /var/cache/opcache ]; then
	echo "🤖 Warming opcache file cache..."
	cd "$APP_BASE_DIR" || exit 0
	php -d opcache.jit=off artisan --version >/dev/null 2>&1 || \
		echo "⚠️ WARNING: opcache warm-up failed, continuing without it" >&2
fi
