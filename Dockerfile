FROM laravelsail/php83-composer

# Set working directory
WORKDIR /var/www/html

RUN docker-php-ext-install pdo_mysql zip

COPY composer.json composer.lock ./

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

# Install dependencies
RUN composer -v
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run build
RUN php artisan filament:upgrade && php artisan filament:assets
RUN php artisan optimize:clear

# Copy application code
COPY . .

# Expose port 8000 (optional)
EXPOSE 1000

# Run Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=1000"]