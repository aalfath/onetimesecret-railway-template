#!/bin/sh
# Start Valkey with durable storage on the Railway volume at /data.
set -eu

if [ -z "${VALKEY_PASSWORD:-}" ]; then
  echo "VALKEY_PASSWORD is not set; refusing to start without a password." >&2
  exit 1
fi

# Railway volumes are root-owned and contain lost+found, so the image's own
# entrypoint would skip its chown and Valkey (uid 999) could not write.
mkdir -p /data
chown -R valkey:valkey /data 2>/dev/null || true

# Append-only file (fsync every second) plus RDB snapshots, as in upstream's
# Compose file, so a restart or redeploy keeps every secret.
exec docker-entrypoint.sh valkey-server \
  --bind '* -::*' \
  --port 6379 \
  --protected-mode no \
  --requirepass "$VALKEY_PASSWORD" \
  --dir /data \
  --appendonly yes \
  --appendfilename onetime.aof \
  --appendfsync everysec \
  --dbfilename onetime.rdb \
  --save '3600 1 300 100 60 10000' \
  --loglevel notice
