#!/usr/bin/env bash
set -euo pipefail

: "${WARPDRIVE_TMUX_SOCKET:?WARPDRIVE_TMUX_SOCKET not set}"

# Idempotent: -A attaches to an existing session if present, otherwise creates;
# -d keeps the result detached either way.
tmux -L "$WARPDRIVE_TMUX_SOCKET" new-session -A -d -s hello-main \
  "bash -lc 'echo \"hello-main session ready\"; exec bash -l'"

echo "open-main: hello-main session is up"
