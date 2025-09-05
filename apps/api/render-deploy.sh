#!/usr/bin/env bash
set -e

echo "Running Laravel deploy steps..."

# Run migrations
php artisan migrate --force

# Cache config, routes, views
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "Laravel deploy finished."
