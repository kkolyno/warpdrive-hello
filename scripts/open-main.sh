#!/usr/bin/env bash
set -euo pipefail

: "${WARPDRIVE_TMUX_SOCKET:?WARPDRIVE_TMUX_SOCKET not set}"

# Idempotent session creation. `tmux new-session -A` with an existing session
# behaves like `attach-session`, which requires a TTY — failing in non-TTY
# contexts like SSH-driven action invocations. Guard with has-session.
if ! tmux -L "$WARPDRIVE_TMUX_SOCKET" has-session -t hello-main 2>/dev/null; then
  tmux -L "$WARPDRIVE_TMUX_SOCKET" new-session -d -s hello-main \
    "bash -lc 'echo \"hello-main session ready\"; exec bash -l'"
fi

echo "open-main: hello-main session is up"
