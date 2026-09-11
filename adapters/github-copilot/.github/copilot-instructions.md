# GitHub Copilot Workspace / CLI Instructions for Shiro X Dev/boost Protocol

When requested to `/boost` or perform high-assurance refactoring:
- **Never edit main branch directly without isolation**: Execute work within `.worktrees/boost-*`.
- **Follow TDD Verification**: Write unit/integration tests that exercise the problem.
- **Physical Verification Required**: Ensure `bash scripts/boost-verify.sh` passes 100% with exit code 0 before finalizing the PR.
