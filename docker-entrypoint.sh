#!/bin/sh

set -e

# Ensure storage and bootstrap cache have correct permissions
chown -R nginx:nginx /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Run artisan only after env is available
if [ -f .env ]; then
    echo "Running Laravel optimization..."
    php artisan optimize:clear || true
    php artisan optimize || true
    php artisan migrate --force || true
else
    echo "No .env file found, skipping artisan optimize"
fi

# Start PHP-FPM in the background
php-fpm &

# Start Nginx in the foreground
nginx -g "daemon off;"
