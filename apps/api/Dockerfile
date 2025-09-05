# 1) Composer deps
FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist
COPY . .
RUN composer install --no-dev --no-interaction --prefer-dist

# 2) Runtime: public PHP + Nginx image
FROM webdevops/php-nginx:8.3
WORKDIR /var/www/html

# Laravel public dir
ENV WEB_DOCUMENT_ROOT=/var/www/html/public

# IMPORTANT: listen on Render's port
ENV WEB_HTTP_PORT=10000
EXPOSE 10000

# Copy app from composer stage
COPY --from=vendor /app /var/www/html

# Permissions
RUN chown -R application:application /var/www/html/storage /var/www/html/bootstrap/cache

# Start script (optional if you have one)
COPY ./render-deploy.sh /usr/local/bin/render-deploy.sh
RUN chmod +x /usr/local/bin/render-deploy.sh
CMD ["bash", "-lc", "render-deploy.sh && /usr/bin/supervisord -n"]
