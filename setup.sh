#!/usr/bin/env bash
set -euo pipefail

ORCH_DIR="$(dirname "$(realpath "$0")")"
STATE_DIR="$(dirname "${WARPDRIVE_STATUS_FILE:?WARPDRIVE_STATUS_FILE not set}")"
HEARTBEAT_PID="${STATE_DIR}/heartbeat.pid"
HEARTBEAT_STOP="${STATE_DIR}/heartbeat.stop"

mkdir -p "$STATE_DIR"

# Clear any leftover stop signal from a previous run.
rm -f "$HEARTBEAT_STOP"

# Atomic status write helper — write to tmp + rename.
write_status() {
  local tmp="${WARPDRIVE_STATUS_FILE}.tmp.$$"
  printf '%s' "$1" > "$tmp"
  mv "$tmp" "$WARPDRIVE_STATUS_FILE"
}

# Initial status.
INITIAL_STATUS=$(cat <<EOF
{
  "health": "healthy",
  "summary": "Setup complete",
  "updatedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "metadata": {
    "greetCount": 0
  }
}
EOF
)
write_status "$INITIAL_STATUS"

# Spawn the heartbeat daemon if not already running.
if [ -f "$HEARTBEAT_PID" ]; then
  PREV_PID=$(cat "$HEARTBEAT_PID" 2>/dev/null || echo "")
  if [ -n "$PREV_PID" ] && kill -0 "$PREV_PID" 2>/dev/null; then
    echo "warpdrive-hello: heartbeat already running (pid=$PREV_PID)"
    exit 0
  fi
fi

nohup "${ORCH_DIR}/scripts/status-writer.sh" >/dev/null 2>&1 &
echo $! > "$HEARTBEAT_PID"

echo "warpdrive-hello: setup complete; heartbeat pid=$(cat "$HEARTBEAT_PID")"
