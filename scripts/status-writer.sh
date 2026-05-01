#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="$(dirname "${WARPDRIVE_STATUS_FILE:?WARPDRIVE_STATUS_FILE not set}")"
HEARTBEAT_STOP="${STATE_DIR}/heartbeat.stop"

write_status() {
  local tmp="${WARPDRIVE_STATUS_FILE}.tmp.$$"
  printf '%s' "$1" > "$tmp"
  mv "$tmp" "$WARPDRIVE_STATUS_FILE"
}

while true; do
  if [ -f "$HEARTBEAT_STOP" ]; then
    rm -f "$HEARTBEAT_STOP"
    exit 0
  fi

  if [ ! -f "$WARPDRIVE_STATUS_FILE" ]; then
    sleep 5
    continue
  fi

  CURRENT=$(cat "$WARPDRIVE_STATUS_FILE")
  NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  # Replace updatedAt only; preserve health, summary, metadata.
  UPDATED=$(printf '%s' "$CURRENT" | jq --arg now "$NOW" '.updatedAt = $now')
  write_status "$UPDATED"
  sleep 5
done
