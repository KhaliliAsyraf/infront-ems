#!/bin/sh
set -e

echo "🚀 Bootstrapping Laravel..."

# Fix permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Run artisan commands only if .env exists
if [ -f .env ]; then
    echo "Running Laravel optimizations..."
    php artisan optimize:clear || true
    php artisan migrate --force || true
    php artisan config:cache || true
    php artisan route:cache || true
    php artisan view:cache || true
else
    echo "⚠️  No .env file found, skipping artisan commands"
fi

echo "✅ Starting Supervisor (PHP-FPM + Nginx)..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
