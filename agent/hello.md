Display the current state of the warpdrive-hello orchestrator and list the actions available to invoke through the WarpDrive API.

When the user runs /hello, you should:

1. Read /ws/.warpdrive/orchestrator/status.json — that's the current orchestrator status. Report `health`, `summary`, `updatedAt`, and `metadata.greetCount` (if present).
2. Read /ws/.warpdrive/orchestrator/greetings.log if it exists — show the most recent 3 entries.
3. Remind the user of the available actions: open-main, greet (params: who, tone), long-task (async).
4. Mention that they can invoke any action via:

   curl -X POST http://localhost:7777/api/sandboxes/default/orchestrator/actions/<id> \
     -H 'content-type: application/json' \
     -d '{"params": {"who": "alice", "tone": "warm"}}'

Keep the response under 12 lines.
