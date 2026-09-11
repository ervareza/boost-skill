---
name: boost
title: "Shiro X Dev/boost"
description: "Shiro X Dev/boost — Universal Multi-Agent Reasoning & Independent Physical Verification Pipeline."
tags: [shiro-x-dev, boost, multi-agent, verification-pipeline, refactoring, deep-reasoning, worktree-isolation]
---

# Shiro X Dev/boost

Universal Multi-Agent Reasoning & Independent Physical Verification Pipeline by Shiro X Dev.
Ported and engineered for Nous Research Hermes Agent (inspired by Google Antigravity `/boost`).

## Quickstart
Trigger via slash command in any Hermes conversation:
```text
/boost <task or prompt>
```

## Protocol Architecture & Workflow Inside Hermes
When the user sends `/boost <prompt>`:
1. **Phase 1: Planning & Ephemeral Worktree Isolation**:
   - Execute `git worktree add -b boost-tmp .worktrees/boost-tmp` via terminal.
   - Preserves 100% pristine active branch state.
2. **Phase 2: Distributed Subagent Topology**:
   - Use `delegate_task` to spawn parallel specialized workers:
     - `investigator`: AST & call-graph analysis, reproduction trace (Read-Only).
     - `implementer`: Surgical atomic patches inside `.worktrees/boost-tmp`.
     - `qa`: Craft reproducible failing test cases (Red-to-Green TDD).
3. **Phase 3: Multi-Round Physical Verification & Self-Healing Loop**:
   - Execute test runner / linter / compiler inside `.worktrees/boost-tmp`.
   - Auto-heal failures with structured error traces (up to 5 rounds).
   - Invariant: Zero code accepted without physical verification (Exit code 0).
4. **Phase 4: Atomic Reconcile & Teardown**:
   - Merge verified worktree commit into the target branch.
   - Cleanly remove the worktree with `git worktree remove .worktrees/boost-tmp`.
