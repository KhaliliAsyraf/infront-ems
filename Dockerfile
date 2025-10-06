FROM php:8.3-fpm

# Install required system dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    git \
    zip \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    curl \
    ca-certificates \
    gnupg2 \
  && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd zip xml \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Allow git to trust project directory (avoids ownership warning)
RUN git config --global --add safe.directory /var/www/html

COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-autoloader --no-progress --no-interaction || true

COPY . .
# Clean old Laravel cache (fixes ghost package discovery issues)
RUN rm -rf bootstrap/cache/*.php config/l5-swagger.php || true \
    && composer install --prefer-dist --no-interaction --optimize-autoloader

RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache || true

COPY docker/php/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

EXPOSE 9000
CMD ["entrypoint"]
