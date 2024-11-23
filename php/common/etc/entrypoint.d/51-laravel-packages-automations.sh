artisan_command_exists() {
    if php "$APP_BASE_DIR/artisan" list | grep -q "$1"; then
        return 0
    else
        return 1
    fi
}

if [ "$DISABLE_DEFAULT_CONFIG" = "false" ]; then
    if [ -f "$APP_BASE_DIR/artisan" ]; then
        if artisan_command_exists "lighthouse:cache"; then
            echo "🚀 Caching nuwave/lighthouse schema..."
            php "$APP_BASE_DIR/artisan" lighthouse:cache -n || true
        fi

        if artisan_command_exists "optimize"; then
            echo "🚀 Running optimize..."
            php "$APP_BASE_DIR/artisan" optimize -n
        fi
    fi
fi
