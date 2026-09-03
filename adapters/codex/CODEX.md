# Boost Protocol for OpenAI Codex CLI

## Invocation & Playbook
When running non-interactive or interactive Codex tasks with high stakes:

```bash
codex exec --sandbox danger-full-access "Run /boost on issue #123: fix WebSocket reconnect race condition"
```

## Autonomous Workflow
1. **Initialize Sandbox Worktree**:
   ```bash
   bash scripts/boost-runner.sh init boost-codex-task
   ```
2. **Execute Multi-Phase Plan**:
   - Trace AST relations and failing edge cases.
   - Write regression unit tests first.
   - Apply minimal surgical fix in `.worktrees/boost-codex-task`.
3. **Verify Physical Output**:
   ```bash
   bash scripts/boost-runner.sh verify boost-codex-task
   ```
4. **Reconcile**:
   ```bash
   bash scripts/boost-runner.sh reconcile boost-codex-task
   ```
