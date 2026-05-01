#!/usr/bin/env bash
set -euo pipefail

: "${WARPDRIVE_TMUX_SOCKET:?WARPDRIVE_TMUX_SOCKET not set}"

# Idempotent: -A attaches to an existing session if present, otherwise creates;
# -d keeps the result detached either way.
tmux -L "$WARPDRIVE_TMUX_SOCKET" new-session -A -d -s hello-main \
  "bash -lc 'echo \"hello-main session ready\"; exec bash -l'"

# Render a banner in the session showing orchestrator state.
tmux -L "$WARPDRIVE_TMUX_SOCKET" send-keys -t hello-main \
  "printf '\\n=== warpdrive-hello: hello-main session opened ===\\n'" Enter

echo "open-main: hello-main session is up"
