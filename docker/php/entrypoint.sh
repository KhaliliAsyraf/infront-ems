#!/usr/bin/env bash
set -e


chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache || true


if [ ! -d "/var/www/html/vendor" ]; then
    composer install --no-interaction --prefer-dist --optimize-autoloader
fi


if php -r "require 'vendor/autoload.php'; echo file_exists('.env') ? 1 : 0;" | grep -q 1; then
    if [ -z "$(php -r "echo getenv('APP_KEY') ?: '';")" ]; then
        php artisan key:generate --force || true
    fi
fi


if [ "${AUTO_MIGRATE:-false}" = "true" ]; then
    php artisan migrate --force || true
fi


php-fpm