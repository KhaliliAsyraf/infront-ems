#!/bin/bash

# Stop on any error
set -e

echo "Running Composer install..."
composer install

echo "Running NPM install..."
npm install

# Only copy .env if it does not exist
if [ ! -f .env ]; then
    echo "Copying .env file..."
    cp .env.example .env
else
    echo ".env already exists, skipping copy."
fi

echo "Generating app key..."
php artisan key:generate

echo "Refreshing database..."
php artisan migrate:fresh

echo "Seeding database..."
php artisan db:seed

echo "Upgrading Filament..."
php artisan filament:upgrade

echo "Publishing Filament assets..."
php artisan filament:assets

echo "Clearing and optimizing caches..."
php artisan optimize:clear

echo "✅ Setup completed successfully!"
