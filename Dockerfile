# Stage 1 - Build Composer dependencies
FROM composer:2 AS vendor

WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Stage 2 - Build frontend (optional)
# If your project uses Node for Vite or Mix, uncomment below
# FROM node:20 AS frontend
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN npm run build

# Stage 3 - PHP + Nginx image
FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    git \
    unzip \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    curl \
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd

# Configure Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy app files
WORKDIR /var/www/html
COPY . .
COPY --from=vendor /app/vendor ./vendor
# COPY --from=frontend /app/public/build ./public/build  # If using Vite

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 8080 for Render
EXPOSE 8080

# Start both PHP-FPM and Nginx
CMD service nginx start && php-fpm
