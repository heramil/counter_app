#!/usr/bin/env bash
set -e

echo "=== Laravel deploy steps ==="

# Clear caches to avoid stale config
php artisan config:clear || true
php artisan route:clear || true
php artisan cache:clear || true

# Run migrations (ok if there are none)
php artisan migrate --force || true

# Optimize caches
php artisan config:cache
php artisan route:cache
php artisan view:cache || true

echo "=== Deploy steps done ==="
