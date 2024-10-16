if [ "$DISABLE_DEFAULT_CONFIG" = "false" ]; then
    if [ -f "$APP_BASE_DIR/artisan" ]; then
        cd $APP_BASE_DIR

        echo "🚀 Caching spatie/laravel-data structures..."
        php artisan data:cache-structures -n || true

        echo "🚀 Caching nuwave/lighthouse schema..."
        php artisan lighthouse:cache -n || true
    fi
fi
