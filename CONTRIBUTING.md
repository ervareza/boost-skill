# Contributing to Boost Skill

Thank you for improving Boost Skill. Keep changes protocol-first, portable, and verifiable.

## Before opening a pull request

1. Read [SPECIFICATION.md](SPECIFICATION.md).
2. Keep the core contract tool-agnostic; put vendor-specific behavior in `adapters/`.
3. Never add secrets, personal tokens, machine-specific absolute paths, or generated build output.
4. Run the complete local check:

   ```bash
   ./scripts/test.sh
   ```

5. Run the installer in an isolated temporary home when changing installation logic:

   ```bash
   ./scripts/test-installer.sh
   ```

6. Test both macOS and Linux behavior when changing shell scripts.
7. Explain compatibility assumptions and any unverified vendor behavior in the PR description.

## Pull request checklist

- [ ] Documentation updated.
- [ ] Adapter paths match the target tool's current official documentation.
- [ ] Existing user files are backed up or never overwritten.
- [ ] Installer is idempotent and supports dry-run.
- [ ] ShellCheck / syntax checks pass.
- [ ] Positive and negative tests cover the change.
- [ ] No claim of native orchestration where the adapter is only an instruction pack.
- [ ] Real verification output is included.

## Design principles

- Prefer one canonical protocol and thin adapters.
- Treat worktrees as change isolation, not a security sandbox.
- Use structured argument passing; do not interpolate untrusted task text into shell commands.
- Preserve user work: dirty-tree detection, backups, explicit destructive actions, and conflict stops are mandatory.
- Fail closed when verification is unavailable or ambiguous.
- Make the smallest change that solves the problem.

## Commit style

Use concise conventional commits, for example:

```text
feat(adapter): add Claude Code plugin manifest
fix(runner): reject dirty target worktrees
 docs: clarify dry-run installation
```
