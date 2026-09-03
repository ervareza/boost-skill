<p align="center">
  <img src="assets/hero-banner.svg" alt="Boost Skill Hero Banner" width="100%" />
</p>

<h1 align="center">⚡ BOOST SKILL (Universal <code>/boost</code> Protocol)</h1>

<p align="center">
  <strong>Multi-Agent Reasoning & Independent Physical Verification Pipeline for All AI Coding CLIs</strong>
</p>

<p align="center">
  <a href="https://github.com/ervareza/boost-skill/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://github.com/ervareza/boost-skill"><img src="https://img.shields.io/badge/version-1.0.0-emerald.svg" alt="Version: 1.0.0"></a>
  <a href="https://github.com/ervareza"><img src="https://img.shields.io/badge/creator-Ervareza%20Naurian-blueviolet.svg" alt="Creator: Ervareza Naurian"></a>
  <img src="https://img.shields.io/badge/inspired%20by-Google%20Antigravity%20/boost-orange.svg" alt="Inspired by Google Antigravity">
</p>

---

## 📖 Introduction & Mission

When Google launched the **`/boost`** slash command in **Google Antigravity CLI (September 2026)**, it introduced a major paradigm shift: moving from single-turn linear AI code generation to a **distributed multi-agent reasoning and verification pipeline**.

Instead of guessing a solution in one go, `/boost` decomposes hard software engineering challenges across specialized subagent teams, isolates changes inside ephemeral Git worktrees, and guarantees that code is delivered **only after test suites pass 100% physically**.

**Boost Skill (`boost-skill`)** brings this exact methodology and execution protocol to **every AI coding CLI and agent environment** in the ecosystem — including Hermes Agent, Claude Code, OpenAI Codex CLI, OpenCode, Aider, Cursor, Windsurf, Roo Code / Cline, Devin, and GitHub Copilot.

---

## 🏛️ 3-Phase Execution Architecture

```
┌───────────────────────────────────────────────────────────────┐
│ 1. PLANNING & WORKSPACE ISOLATION                             │
│    - Scan workspace & map AST call-graphs                     │
│    - Spawn ephemeral Git worktree (`.worktrees/boost-X`)       │
│    - Decompose challenge into verifiable subtasks             │
└───────────────────────────────┬───────────────────────────────┘
                                │ Dispatches
        ┌───────────────────────┼───────────────────────┐
        ▼                       ▼                       ▼
┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│ Investigator     │    │ Implementation   │    │ Verifier / TDD   │
│ Subagent         │    │ Subagent         │    │ Subagent         │
│ (Traces call-    │    │ (Writes surgical │    │ (Builds target & │
│ graph & logs;    │    │ patches in       │    │ exercises tests  │
│ read-only audit) │    │ worktree scope)  │    │ independently)   │
└──────────────────┘    └──────────────────┘    └──────────────────┘
        │                       │                       │
        └───────────────────────┼───────────────────────┘
                                ▼
┌───────────────────────────────────────────────────────────────┐
│ 3. AGGREGATION & AUTO-CORRECTION LOOP                         │
│    - Run full test suite & edge-case assertions               │
│    - If FAIL: route diagnostic traceback to worker (max 5x)   │
│    - If PASS: reconcile changes, merge to branch, & cleanup   │
│    - Deliver ONLY verified results backed by execution logs   │
└───────────────────────────────────────────────────────────────┘
```

---

## 🚀 Quickstart Guides for Top 10 AI Coding CLIs

### 1. 🪽 Nous Research Hermes Agent
Add the skill to your Hermes skills directory:
```bash
# Copy to global Hermes skills
cp adapters/hermes/SKILL.md ~/.hermes/skills/autonomous-ai-agents/boost/SKILL.md
```
**Usage:**
```text
/boost Fix intermittent race condition when WebSocket reconnects during token refresh
```

---

### 2. 🟣 Claude Code CLI (Anthropic)
Copy the protocol directives to your project root or global instructions:
```bash
cp adapters/claude-code/CLAUDE.md ./CLAUDE.md
```
**Usage:**
```bash
claude "Run /boost on issue: optimize database N+1 query and add regression tests"
```

---

### 3. 🟢 OpenAI Codex CLI
Use the Codex sandbox execution wrapper:
```bash
codex exec --sandbox danger-full-access "Execute /boost protocol on task: refactor authentication middleware"
```

---

### 4. ⚡ OpenCode CLI
Register the OpenCode boost agent rule:
```bash
cp adapters/opencode/opencode.json ~/.opencode/plugins/boost.json
```

---

### 5. 🤖 Aider
Enable Architect mode with the Boost verification test runner:
```bash
cp adapters/aider/.aider.conf.yml ./.aider.conf.yml
aider --architect --test-cmd "bash scripts/boost-verify.sh"
```

---

### 6. 🖱️ Cursor & Composer
Drop the `.cursorrules` or `.cursor/rules/boost.mdc` into your repository:
```bash
cp adapters/cursor/.cursorrules ./.cursorrules
```

---

### 7. 🌊 Windsurf (Cascade)
Enable Cascade Boost workflows:
```bash
cp adapters/windsurf/.windsurfrules ./.windsurfrules
```

---

### 8. 🦘 Roo Code / Cline
Import the `Boost Engineer` custom mode:
```bash
cp adapters/roo-cline/.roomodes ./.roomodes
```

---

### 9. 🧠 Devin / Devin ACP
Include `adapters/devin/devin-boost.md` in your task playbook prompts.

---

### 10. 🐙 GitHub Copilot (Workspace & CLI)
Add instructions to your repo `.github` folder:
```bash
mkdir -p .github && cp adapters/github-copilot/.github/copilot-instructions.md .github/copilot-instructions.md
```

---

## 🛠️ Included Automation Scripts

* **`scripts/boost-runner.sh`**: Automates worktree creation, testing, merge reconciliation, and cleanup.
  ```bash
  bash scripts/boost-runner.sh init my-task     # Create ephemeral worktree
  bash scripts/boost-runner.sh verify my-task   # Run test suites inside worktree
  bash scripts/boost-runner.sh reconcile my-task# Merge verified code & prune worktree
  ```
* **`scripts/boost-verify.sh`**: Universal polyglot test runner supporting Node.js/TypeScript, Python, Go, Rust, and Flutter.

---

## 📜 Core Guarantees & Invariants

1. **Zero Working Tree Pollution**: All exploratory edits live in ephemeral Git worktrees until 100% verified.
2. **Physical Test Backing**: A task is never marked done based on visual inspection alone; exit code 0 is mandatory.
3. **Bounded Iteration**: Auto-heals compile and test errors up to 5 iterations before escalating to the developer.

---

## 👤 Author & Credits

* **Engineered by:** **Ervareza Naurian** ([@ervareza](https://github.com/ervareza))
* **Email:** `rianskp644@gmail.com`
* **Inspiration:** Google Antigravity CLI `/boost` Architecture (September 2026)
* **License:** [MIT](LICENSE)
