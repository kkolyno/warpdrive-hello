---
name: orchestrator-helper
description: Use when the user asks about the warpdrive-hello orchestrator running in this workspace — its current status, available actions, or how to invoke them through the WarpDrive API.
---

# Orchestrator Helper Skill

This skill is installed by the warpdrive-hello reference orchestrator via `userAgentIntegration.files[]`. It teaches Claude how to interact with the orchestrator's contract surface.

## Status

The orchestrator's status is at `/ws/.warpdrive/orchestrator/status.json`. The shape:

```json
{
  "health": "healthy" | "degraded" | "offline",
  "summary": "human-readable status string",
  "updatedAt": "ISO-8601 timestamp",
  "metadata": { "greetCount": 0 }
}
```

## Available actions

- `open-main` — creates the `hello-main` tmux session.
- `greet` — params: `who` (required string), `tone` (optional enum: warm, formal, terse). Appends to `/ws/.warpdrive/orchestrator/greetings.log`.
- `long-task` — async; spawns a 30s background subprocess that updates status as it progresses.

## Invoking actions

```
curl -X POST http://localhost:7777/api/sandboxes/default/orchestrator/actions/<id> \
  -H 'content-type: application/json' \
  -d '{"params": {...}}'
```

Async actions return 202 immediately. Sync actions return 200 with `stdout`, `stderr`, `exitCode`, and (if the action declares `session`) a `terminalTarget` block.
