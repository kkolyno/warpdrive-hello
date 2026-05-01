#!/usr/bin/env bash
set -euo pipefail

WHO="${PARAM_who:?PARAM_who is required}"
TONE="${PARAM_tone:-warm}"

STATE_DIR="$(dirname "${WARPDRIVE_STATUS_FILE:?WARPDRIVE_STATUS_FILE not set}")"
LOG="${STATE_DIR}/greetings.log"

case "$TONE" in
  warm)   GREETING="Hello, $WHO — warm wishes from warpdrive-hello." ;;
  formal) GREETING="Greetings, $WHO. The hello-world orchestrator acknowledges you." ;;
  terse)  GREETING="hi $WHO" ;;
  *)      echo "greet: unknown tone '$TONE'" >&2; exit 2 ;;
esac

mkdir -p "$STATE_DIR"
printf '%s\n' "$GREETING" >> "$LOG"
echo "$GREETING"

# Atomic status update: bump greetCount, set summary.
write_status() {
  local tmp="${WARPDRIVE_STATUS_FILE}.tmp.$$"
  printf '%s' "$1" > "$tmp"
  mv "$tmp" "$WARPDRIVE_STATUS_FILE"
}

NOW="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
UPDATED=$(jq \
  --arg who "$WHO" \
  --arg now "$NOW" \
  '.summary = "Greeted \($who)" | .updatedAt = $now | .metadata.greetCount = ((.metadata.greetCount // 0) + 1)' \
  "$WARPDRIVE_STATUS_FILE")

write_status "$UPDATED"
