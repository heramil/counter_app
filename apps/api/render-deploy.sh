#!/usr/bin/env bash
set -e

echo "Composer optimize..."
composer install --no-dev --prefer-dist --no-interaction || true

php artisan key:generate --force || true
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "Run migrations..."
php artisan migrate --force
