---
name: boost
description: "Use when /boost or solving complex verified coding tasks."
tags: [boost, multi-agent, verification-pipeline, refactoring, deep-reasoning, worktree-isolation]
---

# Boost Skill for Hermes Agent

Brings the multi-agent reasoning and independent verification pipeline inspired by Google Antigravity `/boost` to Nous Research Hermes Agent.

## Quickstart
Add this file to `~/.hermes/skills/autonomous-ai-agents/boost/SKILL.md` or invoke:
```bash
hermes skill install boost
```

## Workflow Inside Hermes
When the user sends `/boost <prompt>`:
1. **Phase 1**: Execute `git worktree add -b boost-tmp .worktrees/boost-tmp` via terminal.
2. **Phase 2**: Use `delegate_task` to spawn parallel workers:
   - `investigator`: Trace symbols and root-causes.
   - `implementer`: Write surgical code edits inside `.worktrees/boost-tmp`.
   - `qa`: Craft failing test cases and execute them.
3. **Phase 3**: Run the test runner in `.worktrees/boost-tmp`. Auto-heal failures (up to 5 rounds).
4. Reconcile verified changes to the active branch and cleanup the worktree.
