#!/bin/sh
set -e

echo "🔧 Preparing Laravel application..."

# Fix permissions (only if needed)
if [ ! -w /var/www/html/storage ]; then
    echo "Fixing permissions..."
    chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
fi

# Run artisan optimization & migration if .env exists
if [ -f .env ]; then
    echo "Running artisan commands..."
    php artisan optimize:clear || true
    php artisan migrate --force || true
    php artisan optimize || true
else
    echo "⚠️  No .env file found, skipping artisan commands"
fi

echo "✅ Laravel ready. Starting services..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
