#!/bin/bash
set -e

echo "🚀 Starting Laravel container..."

# Wait a bit for DB to be ready (Render sometimes starts DB service slightly later)
sleep 5

echo "🧹 Clearing and rebuilding Laravel caches..."
php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "🗄️ Running database migrations..."
php artisan migrate --force || echo "⚠️ Migration failed (possibly already up to date). Continuing..."

echo "✅ Starting Nginx and PHP-FPM..."
service nginx start
php-fpm
