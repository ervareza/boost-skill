# Shiro X Dev/boost Protocol for Claude Code CLI

When the user prefixes a prompt with `/boost` or asks for a deep verified refactor/fix:

## Execution Invariants
1. **Worktree Isolation**: Never edit files in the root repo directly for complex issues. Run:
   ```bash
   bash scripts/boost-runner.sh init boost-<task-slug>
   ```
2. **Subagent Orchestration**: Use Claude Code's subagent capabilities or execute distinct step sequences:
   - Step 1: Investigation & Trace (`grep`, `find`, read-only inspection)
   - Step 2: Implementation in `.worktrees/boost-<task-slug>`
   - Step 3: Physical Verification (`bash scripts/boost-verify.sh`)
3. **Multi-Round Self-Healing**: If tests fail, diagnose the traceback and patch again. Do not give up until test suites exit 0.
4. **Reconciliation**:
   ```bash
   bash scripts/boost-runner.sh reconcile boost-<task-slug>
   ```
5. **Honest Delivery**: Report real test results verbatim.
