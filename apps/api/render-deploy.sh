#!/usr/bin/env bash
set -euo pipefail

echo "=== Laravel deploy steps (API) ==="

# Clear any stale caches first (safe even on fresh boot)
php artisan optimize:clear || true

# Ensure APP_KEY exists (only needed once per env)
php artisan key:generate --force || true

# Detect closure routes; if present, route:cache will break
if grep -R --include='*.php' -nE "Route::(get|post|put|patch|delete|options)\s*\(\s*['\"][^'\"]+['\"]\s*,\s*function" routes >/dev/null 2>&1; then
  echo "Detected closure routes — will skip route:cache."
  SKIP_ROUTE_CACHE=1
else
  SKIP_ROUTE_CACHE=0
fi

# Wait for DB & run migrations (retry because DB can be slow to accept connections)
attempts=20
sleep_sec=3
i=1
until php artisan migrate --force; do
  status=$?
  echo "[migrate] attempt $i/$attempts failed (code=$status). Retrying in ${sleep_sec}s..."
  if [ "$i" -ge "$attempts" ]; then
    echo "[migrate] giving up after $attempts attempts."
    exit $status
  fi
  i=$((i+1))
  sleep "$sleep_sec"
done

# Rebuild caches
php artisan config:cache
[ "$SKIP_ROUTE_CACHE" -eq 0 ] && php artisan route:cache || true
php artisan view:cache || true

# Public storage (safe if it already exists)
php artisan storage:link || true

echo "=== Deploy steps done ==="
