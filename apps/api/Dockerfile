# --- 1) Composer deps (build stage) ---
FROM composer:2 AS vendor
WORKDIR /app
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_NO_INTERACTION=1

COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-scripts --no-progress --no-ansi

COPY . .
RUN composer install --no-dev --prefer-dist --no-progress --no-ansi

# --- 2) Runtime: PHP + Nginx ---
FROM webdevops/php-nginx:8.3
WORKDIR /var/www/html
ENV WEB_DOCUMENT_ROOT=/var/www/html/public
ENV WEB_HTTP_PORT=10000
EXPOSE 10000

# Copy app
COPY --from=vendor /app /var/www/html

# Permissions for Laravel
RUN chown -R application:application /var/www/html/storage /var/www/html/bootstrap/cache

# Deploy script (called by Render preDeploy, not at container start)
COPY ./render-deploy.sh /usr/local/bin/render-deploy.sh
RUN chmod +x /usr/local/bin/render-deploy.sh

# Start web stack; Render sets $PORT → we propagate to Nginx
CMD ["bash", "-lc", "export WEB_HTTP_PORT=${PORT:-10000}; /usr/bin/supervisord -n"]
