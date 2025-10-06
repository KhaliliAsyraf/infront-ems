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

# Copy composer files first for caching
COPY composer.json composer.lock ./

RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# Copy rest of the Laravel project
COPY . .

# Build assets
RUN npm ci && npm run build

# Copy Nginx config
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Supervisor to manage both PHP-FPM and Nginx
COPY supervisor.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
