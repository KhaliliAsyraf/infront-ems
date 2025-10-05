# =====================================
# 1️⃣ Base PHP image with required extensions
# =====================================
FROM php:8.3-fpm

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libicu-dev libzip-dev zip unzip git curl nodejs npm \
    && docker-php-ext-install intl pdo pdo_mysql opcache zip \
    && docker-php-ext-enable intl zip

# Set working directory
WORKDIR /var/www/html

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

# Copy composer files first for caching
COPY composer.json composer.lock ./

# ✅ Allow Composer plugins when running as root (Render builds as root)
RUN composer config --global allow-plugins true

# ✅ Install PHP dependencies but skip scripts (artisan not copied yet)
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress --no-scripts

# Copy the rest of the Laravel app
COPY . .

# ✅ Now run post-autoload scripts after artisan exists
RUN composer run-script post-autoload-dump

# =====================================
# 2️⃣ Build frontend assets
# =====================================
RUN npm ci && npm run build

# =====================================
# 3️⃣ Laravel optimization
# =====================================
# RUN php artisan optimize:clear && php artisan optimize
# Skip artisan during build (env not available)
# Run optimization later when the container starts

# =====================================
# 4️⃣ Nginx stage
# =====================================
FROM nginx:stable-alpine

# Copy Nginx configuration
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy built Laravel app from previous stage
COPY --from=0 /var/www/html /var/www/html

# Set working directory
WORKDIR /var/www/html

# Expose port for Render
EXPOSE 80

# Entrypoint script to ensure permissions and start both PHP-FPM and Nginx
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
