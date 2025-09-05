# --- 1) Composer deps (build stage) ---
FROM composer:2 AS vendor
WORKDIR /app

# Allow composer as root in container
ENV COMPOSER_ALLOW_SUPERUSER=1
# (Optional but nice: speed up Composer a bit)
ENV COMPOSER_NO_INTERACTION=1

# Install deps WITHOUT scripts first (artisan not present yet)
COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-scripts --no-progress --no-ansi

# Now copy the full app (includes artisan)
COPY . .

# Run again so post-install scripts (artisan) can run, and autoload is optimized
RUN composer install --no-dev --prefer-dist --no-progress --no-ansi

# --- 2) Runtime: PHP + Nginx ---
FROM webdevops/php-nginx:8.3
WORKDIR /var/www/html

# Serve Laravel public/
ENV WEB_DOCUMENT_ROOT=/var/www/html/public

# IMPORTANT: Render will inject $PORT; default to 10000 if missing
ENV WEB_HTTP_PORT=10000
EXPOSE 10000

# Copy application code from the vendor stage
COPY --from=vendor /app /var/www/html

# Permissions for Laravel
RUN chown -R application:application /var/www/html/storage /var/www/html/bootstrap/cache

# Deploy script (migrations + caches). Keep it idempotent.
COPY ./render-deploy.sh /usr/local/bin/render-deploy.sh
RUN chmod +x /usr/local/bin/render-deploy.sh

# Start: set port from $PORT (Render) and boot supervisord (nginx + php-fpm) after deploy script
# If you prefer moving migrations to Render "Pre-Deploy Command", you can drop render-deploy.sh and simplify this.
CMD ["bash", "-lc", "export WEB_HTTP_PORT=${PORT:-10000}; /usr/local/bin/render-deploy.sh && /usr/bin/supervisord -n"]
