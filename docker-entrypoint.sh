#!/bin/sh

set -e

# Ensure storage and bootstrap cache have correct permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Clear and optimize Laravel before serving
php artisan optimize:clear
php artisan optimize

# Start PHP-FPM in the background
php-fpm &

# Start Nginx in the foreground
nginx -g "daemon off;"
