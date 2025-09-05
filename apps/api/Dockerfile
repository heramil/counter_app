# --- Composer deps layer ---
FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist
COPY . .
RUN composer install --no-dev --no-interaction --prefer-dist

# --- Runtime image: Nginx + PHP-FPM 8.3 ---
FROM ghcr.io/renderinc/nginx-php-fpm:8.3
WORKDIR /var/www/html

# copy app
COPY --from=vendor /app /var/www/html

# Laravel storage/cache permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# boot script to optimize & migrate
COPY ./render-deploy.sh /usr/local/bin/render-deploy.sh
RUN chmod +x /usr/local/bin/render-deploy.sh

EXPOSE 10000
CMD ["bash", "-lc", "render-deploy.sh && /usr/local/bin/start"]
