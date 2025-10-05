# Stage 1 - Composer dependencies
FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# Stage 2 - Frontend build (if using Vite)
FROM node:20 AS frontend
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 3 - Laravel runtime
FROM php:8.3-fpm

# Install system dependencies & PHP extensions
RUN apt-get update && apt-get install -y \
    nginx \
    git \
    unzip \
    libicu-dev \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    curl \
    && docker-php-ext-install intl pdo_mysql mbstring zip exif pcntl bcmath gd

# Copy Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Set working directory
WORKDIR /var/www/html

# Copy Laravel app files
COPY . .

# Copy vendor + built assets
COPY --from=vendor /app/vendor ./vendor
COPY --from=frontend /app/public/build ./public/build

# Copy the startup script
COPY start-container.sh /usr/local/bin/start-container.sh
RUN chmod +x /usr/local/bin/start-container.sh

# Expose Render’s required port
EXPOSE 8080

# Run startup script (migrate + optimize + start services)
CMD ["bash", "/usr/local/bin/start-container.sh"]
