#!/usr/bin/env node

/**
 * boost-skill CLI
 * Universal /boost Multi-Agent Reasoning & Verification Pipeline
 * Author: Ervareza Naurian (@ervareza)
 */

import { spawnSync } from "node:child_process";
import { existsSync, mkdirSync, cpSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { homedir } from "node:os";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const ROOT = join(__dirname, "..");

const args = process.argv.slice(2);
const command = args[0] || "help";
const taskName = args[1] || `boost-task-${Date.now()}`;

function printBanner() {
  console.log(`\x1b[36m
  ____                   _     ____  _     _ _ _ 
 | __ )  ___   ___  ___ | |_  / ___|| | _ (_) | |
 |  _ \ / _ \ / _ \/ __|| __| \___ \| |/ /| | | |
 | |_) | (_) | (_) \__ \| |_   ___) |   < | | | |
 |____/ \___/ \___/|___/ \__| |____/|_|\_\|_|_|_|
\x1b[0m
  \x1b[1m⚡ Universal /boost Multi-Agent Reasoning & Verification Protocol\x1b[0m
  \x1b[90mEngineered by Ervareza Naurian • Inspired by Google Antigravity /boost\x1b[0m\n`);
}

function runScript(scriptName, scriptArgs = []) {
  const scriptPath = join(ROOT, "scripts", scriptName);
  const result = spawnSync("bash", [scriptPath, ...scriptArgs], {
    stdio: "inherit",
    shell: true,
  });
  return result.status === 0;
}

switch (command) {
  case "install": {
    printBanner();
    console.log("📦 Installing Boost Skill into local agent environments...\n");
    const home = homedir();
    
    // Hermes
    const hermesPath = join(home, ".hermes", "skills", "autonomous-ai-agents", "boost");
    mkdirSync(hermesPath, { recursive: true });
    cpSync(join(ROOT, "adapters", "hermes", "SKILL.md"), join(hermesPath, "SKILL.md"));
    console.log("  \x1b[32m✓\x1b[0m Installed to Hermes Agent (~/.hermes/skills/autonomous-ai-agents/boost/)");

    // Claude Code
    const claudePath = join(home, ".claude", "skills");
    mkdirSync(claudePath, { recursive: true });
    cpSync(join(ROOT, "adapters", "claude-code", "CLAUDE.md"), join(claudePath, "boost.md"));
    console.log("  \x1b[32m✓\x1b[0m Installed to Claude Code (~/.claude/skills/boost.md)");

    // Codex
    const codexPath = join(home, ".codex", "rules");
    mkdirSync(codexPath, { recursive: true });
    cpSync(join(ROOT, "adapters", "codex", "CODEX.md"), join(codexPath, "boost.md"));
    console.log("  \x1b[32m✓\x1b[0m Installed to OpenAI Codex CLI (~/.codex/rules/boost.md)");

    // OpenCode
    const opencodePath = join(home, ".opencode", "plugins");
    mkdirSync(opencodePath, { recursive: true });
    cpSync(join(ROOT, "adapters", "opencode", "opencode.json"), join(opencodePath, "boost.json"));
    console.log("  \x1b[32m✓\x1b[0m Installed to OpenCode (~/.opencode/plugins/boost.json)");

    console.log("\n\x1b[32m✨ Boost Skill is now ready across your AI agents!\x1b[0m");
    break;
  }

  case "init":
    printBanner();
    runScript("boost-runner.sh", ["init", taskName]);
    break;

  case "verify":
    printBanner();
    runScript("boost-runner.sh", ["verify", taskName]);
    break;

  case "reconcile":
    printBanner();
    runScript("boost-runner.sh", ["reconcile", taskName]);
    break;

  case "abort":
    printBanner();
    runScript("boost-runner.sh", ["abort", taskName]);
    break;

  case "test":
    printBanner();
    runScript("boost-verify.sh");
    break;

  case "help":
  default:
    printBanner();
    console.log(`Usage:
  \x1b[36mboost install\x1b[0m               Install adapters to Hermes, Claude, Codex & OpenCode
  \x1b[36mboost init <task_name>\x1b[0m      Spawn an isolated ephemeral Git worktree
  \x1b[36mboost verify <task_name>\x1b[0m    Execute physical test & compiler verification
  \x1b[36mboost reconcile <task_name>\x1b[0m Merge verified code into current branch & cleanup
  \x1b[36mboost abort <task_name>\x1b[0m     Prune worktree and discard changes
  \x1b[36mboost test\x1b[0m                  Run polyglot test suite in the current directory
`);
    break;
}
