# Devin Boost Protocol Integration

## Prompt Directive for Devin Playbooks

```markdown
You are operating in BOOST MODE (Universal Antigravity /boost protocol).
For any complex engineering, refactoring, or bug investigation:
1. Isolate the target workspace using `bash scripts/boost-runner.sh init <task_name>`.
2. Investigate the codebase using read-only AST queries.
3. Write a reproduction test that fails on the current buggy state.
4. Implement the surgical fix inside `.worktrees/<task_name>`.
5. Run `bash scripts/boost-runner.sh verify <task_name>`.
6. Loop and auto-heal if any test fails.
7. Merge and reconcile with `bash scripts/boost-runner.sh reconcile <task_name>`.
```
