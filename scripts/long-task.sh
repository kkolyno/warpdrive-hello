#!/usr/bin/env bash
set -euo pipefail

ORCH_DIR="$(dirname "$(dirname "$(realpath "$0")")")"
WORKER="${ORCH_DIR}/scripts/.long-task-worker.sh"

# Generate the worker script inline so this action stays self-contained.
cat > "$WORKER" <<'WORKER_EOF'
#!/usr/bin/env bash
set -euo pipefail
write_status() {
  local tmp="${WARPDRIVE_STATUS_FILE}.tmp.$$"
  printf '%s' "$1" > "$tmp"
  mv "$tmp" "$WARPDRIVE_STATUS_FILE"
}

for i in 1 2 3 4 5 6; do
  NOW="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  UPDATED=$(jq \
    --arg summary "Long task: ${i}/6" \
    --arg now "$NOW" \
    '.summary = $summary | .updatedAt = $now | .metadata.lastTick = $now' \
    "$WARPDRIVE_STATUS_FILE")
  write_status "$UPDATED"
  sleep 5
done

NOW="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
UPDATED=$(jq \
  --arg now "$NOW" \
  '.summary = "Long task complete" | .updatedAt = $now | .metadata.taskCompletedAt = $now' \
  "$WARPDRIVE_STATUS_FILE")
write_status "$UPDATED"
WORKER_EOF
chmod +x "$WORKER"

# Spawn the worker detached and return immediately.
nohup "$WORKER" >/dev/null 2>&1 &
echo "long-task: spawned worker pid=$!"
