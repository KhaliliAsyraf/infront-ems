FROM laravelsail/php83-composer

# Set working directory
WORKDIR /var/www/html

# Copy application code
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run build
RUN php artisan filament:upgrade && php artisan filament:assets
RUN php artisan optimize:clear

# Expose port 8000 (optional)
EXPOSE 1000

# Run Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=1000"]