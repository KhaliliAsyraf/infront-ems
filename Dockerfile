FROM php:8.3-fpm

# Install system dependencies and Nginx
RUN apt-get update && apt-get install -y \
    nginx libicu-dev libzip-dev zip unzip git curl nodejs npm supervisor \
    && docker-php-ext-install intl pdo pdo_mysql opcache zip \
    && docker-php-ext-enable intl zip \
    && mkdir -p /run/php /var/www/html /var/log/supervisor

WORKDIR /var/www/html

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

# ✅ Copy composer files first
COPY composer.json composer.lock ./

# ✅ Allow composer plugins when running as root
RUN composer config --global allow-plugins true

# ✅ Install dependencies without running artisan (because not copied yet)
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress --no-scripts

# ✅ Now copy full Laravel project (artisan, routes, etc.)
COPY . .

# ✅ Now that artisan exists, re-run autoload dump
RUN composer dump-autoload --optimize

# ✅ Build frontend assets
RUN npm ci && npm run build

# Copy Nginx config
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Copy Supervisor config
COPY supervisor.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

# Start both PHP-FPM and Nginx
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
