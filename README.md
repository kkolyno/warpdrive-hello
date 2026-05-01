# warpdrive-hello

The reference orchestrator for [WarpDrive](https://warpdrive.md). Demonstrates every documented surface of the orchestrator contract — copy this repo as the starting point when authoring your own orchestrator.

## What it does

- `setup.sh` writes an initial status JSON and spawns a 5-second-heartbeat status writer.
- `open-main` action creates a tmux session named `hello-main`.
- `greet` action takes a required `who` (string) and optional `tone` (enum) param, appends a greeting line, bumps a counter in status `metadata`.
- `long-task` action spawns a 30-second background subprocess that updates status as it ticks.
- `userAgentIntegration` installs a `/hello` slash command and a discoverable skill into the workspace's Claude Code config.

## Using as a template

```bash
git clone https://github.com/kkolyno/warpdrive-hello.git my-orchestrator
cd my-orchestrator
rm -rf .git && git init
# edit warpdrive.manifest.yml: change `name`, scripts, sessions, actions
```

Then point WarpDrive at your repo:

```bash
curl -X POST http://localhost:7777/api/config/orchestrator \
  -H 'content-type: application/json' \
  -d '{"repo":"https://github.com/you/my-orchestrator.git"}'
```

See the WarpDrive [orchestrator manifest reference](https://warpdrive.md/docs) for the full contract.

## License

MIT
