# Specification: Shiro X Dev/boost Multi-Agent Protocol

**Version:** 1.0.0  
**Author:** Ervareza Naurian / Shiro X Dev ([@ervareza](https://github.com/ervareza))  
**Origin:** Inspired by Google Antigravity CLI `/boost` Architecture (September 2026)  
**Target Environments:** Hermes Agent, Claude Code, OpenAI Codex CLI, OpenCode, Aider, Cursor, Windsurf, Roo Code / Cline, Devin, GitHub Copilot.

---

## 1. Executive Overview

Conventional single-turn AI coding assistants operate in a linear generation model:
$$\text{Prompt} \longrightarrow \text{Direct File Patch} \longrightarrow \text{User Review}$$

This linear model frequently collapses on **hard software engineering challenges**:
1. **Concurrency Bugs & Race Conditions**: Flaws depend on subtle execution order that cannot be verified by reading static code alone.
2. **Multi-File Structural Refactoring**: Changes across 10+ modules produce silent cascading regressions.
3. **Ghost Regressions (Heisenbugs)**: Bugs that appear or disappear during debugging.

The `/boost` protocol enforces a **3-Phase Verification Pipeline**:
$$\text{Prompt} \longrightarrow \text{Worktree Isolation} \longrightarrow \text{Parallel Subagent Teams} \longrightarrow \text{Multi-Round Auto-Healing Loop} \longrightarrow \text{Verified Delivery}$$

---

## 2. Core Protocol Architecture

```
[ Incoming /boost Request ]
           │
           ▼
┌──────────────────────────────────────────────────────────────┐
│ PHASE 1: PLANNING & WORKSPACE ISOLATION                     │
│ - Invariant: Never touch active working tree directly.       │
│ - Create isolated Git worktree: `.worktrees/boost-<uuid>`    │
│ - AST Call-Graph Mapping & Task Decomposition                │
└──────────────────────────────┬───────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────┐
│ PHASE 2: DISTRIBUTED SUBAGENT TOPOLOGY                      │
│                                                              │
│ ┌──────────────────┐ ┌──────────────────┐ ┌────────────────┐ │
│ │  Investigator    │ │  Implementation  │ │  Test Crafter  │ │
│ │  Worker          │ │  Worker          │ │  (TDD QA)      │ │
│ │  (Read-Only AST) │ │  (Surgical Code) │ │  (Red to Green)│ │
│ └──────────────────┘ └──────────────────┘ └────────────────┘ │
└──────────────────────────────┬───────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────┐
│ PHASE 3: MULTI-ROUND VERIFICATION & RECONCILIATION LOOP     │
│ - Run real build targets & test runner in worktree           │
│ - Assertion Check:                                           │
│   ├── PASS: Merge worktree commit -> Cleanup -> Deliver      │
│   └── FAIL: Feed diagnostic trace to Implementer (Max 5x)    │
└──────────────────────────────────────────────────────────────┘
```

---

## 3. Protocol Invariants & Rules

### Invariant 1: Ephemeral Worktree Isolation
- All exploratory modifications, debugging instrumentations, and test experiments **MUST** occur inside an ephemeral Git worktree:
  ```bash
  BOOST_ID="boost-$(date +%s)"
  git worktree add -b "$BOOST_ID" ".worktrees/$BOOST_ID"
  ```
- The developer's main branch and uncommitted staging area remain pristine throughout the entire execution.

### Invariant 2: Specialized Subagent Roles
Instead of a single monolithic model attempting to do everything:
1. **The Investigator (Auditor)**: Traverses symbols, call graphs, recent git history, and reproduction logs without write permissions.
2. **The Implementer (Engineer)**: Applies atomic, surgical modifications focused exclusively on the root-cause hypothesis.
3. **The Verifier (QA / Test Crafter)**: Writes reproducible test cases (failing first / Red), validates compiler output, linters, and runtime test assertions (Green).

### Invariant 3: Zero-Assumption Physical Verification
- A `/boost` workflow is strictly forbidden from claiming a bug is resolved based on visual code inspection.
- The deliverable **MUST** be substantiated by actual process execution logs (Exit code 0, test pass counts, build checksums).

### Invariant 4: Bounded Auto-Correction Loop
- Maximum iteration depth: **5 rounds**.
- When an assertion fails during Phase 3, the orchestrator packages:
  - Failing assertion name and stack trace
  - Exact diff introduced in the current round
  - Runtime environment log
- This diagnostic package is fed into the Implementer worker for targeted repair.

### Invariant 5: Clean Teardown & Atomic Reconcile
Upon successful verification (Exit 0, 100% tests passing):
1. Commit changes inside the worktree with a descriptive commit message.
2. Fast-forward or merge the verified branch into the target branch.
3. Prune the ephemeral worktree:
   ```bash
   git worktree remove ".worktrees/$BOOST_ID" --force
   git branch -D "$BOOST_ID" 2>/dev/null || true
   ```

---

## 4. Verification Engine Compatibility Matrix

| CLI / Environment | Native Mechanism | Boost Adapter Strategy |
| :--- | :--- | :--- |
| **Hermes Agent** | `delegate_task` + `terminal` | Native skill (`~/.hermes/skills/boost/SKILL.md`) |
| **Claude Code** | Task tool + subagent spawning | `CLAUDE.md` + slash command prompt |
| **OpenAI Codex CLI** | `codex exec` sandbox + multi-step | `CODEX.md` + execution playbook |
| **OpenCode** | Subagent plugins + workspace rules | `opencode.json` / rule manifest |
| **Aider** | Architect / Editor dual-model | `.aider.conf.yml` + `/run boost-verify.sh` |
| **Cursor** | Composer + Background Agents | `.cursorrules` / `.cursor/rules/boost.mdc` |
| **Windsurf** | Cascade workflows | `.windsurfrules` workflow definition |
| **Roo Code / Cline** | Custom Mode Engine | `.roomodes` (`Boost Engineer` mode) |
| **Devin** | Ephemeral cloud environments | `devin-boost.md` execution prompt |
| **GitHub Copilot** | Workspace instructions | `.github/copilot-instructions.md` |
