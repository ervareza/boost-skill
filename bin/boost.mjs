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
const taskName = args[1] || "";

function printBanner() {
  console.log(`\x1b[36m
  ____                   _     ____  _     _ _ _ 
 | __ )  ___   ___  ___ | |_  / ___|| | _ (_) | |
 |  _ \\ / _ \\ / _ \\/ __|| __| \\___ \\| |/ /| | | |
 | |_) | (_) | (_) \\__ \\| |_   ___) |   < | | | |
 |____/ \\___/ \\___/|___/ \\__| |____/|_|\\_\\|_|_|_|
\x1b[0m
  \x1b[1m⚡ Shiro X Dev/boost — Universal Multi-Agent Reasoning & Verification Protocol\x1b[0m
  \x1b[90mEngineered by Ervareza Naurian (Shiro X Dev) • Inspired by Google Antigravity /boost\x1b[0m\n`);
}

// Invariant: task name security validation (alphanumeric + safe symbols)
function validateTaskName(name) {
  if (!name) return true;
  const safeRegex = /^[A-Za-z0-9][A-Za-z0-9._-]*$/;
  if (!safeRegex.test(name) || name.includes("..")) {
    console.error(`\x1b[31m❌ Error:\x1b[0m Invalid task name '${name}'. Allowed: [A-Za-z0-9._-], no path traversal.`);
    process.exit(1);
  }
  return true;
}

function runScript(scriptName, scriptArgs = []) {
  const scriptPath = join(ROOT, "scripts", scriptName);
  const result = spawnSync("bash", [scriptPath, ...scriptArgs], {
    stdio: "inherit",
    shell: false, // Invariant: no shell injection
  });
  
  if (result.status !== 0) {
    process.exit(result.status || 1);
  }
  return true;
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
    validateTaskName(taskName);
    runScript("boost-runner.sh", taskName ? ["init", taskName] : ["init"]);
    break;

  case "verify":
    printBanner();
    validateTaskName(taskName);
    runScript("boost-runner.sh", taskName ? ["verify", taskName] : ["verify"]);
    break;

  case "reconcile":
    printBanner();
    validateTaskName(taskName);
    runScript("boost-runner.sh", taskName ? ["reconcile", taskName] : ["reconcile"]);
    break;

  case "abort":
    printBanner();
    validateTaskName(taskName);
    runScript("boost-runner.sh", taskName ? ["abort", taskName] : ["abort"]);
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
  \x1b[36mboost init [task_name]\x1b[0m      Spawn an isolated ephemeral Git worktree
  \x1b[36mboost verify <task_name>\x1b[0m    Execute physical test & compiler verification
  \x1b[36mboost reconcile <task_name>\x1b[0m Merge verified code into current branch & cleanup
  \x1b[36mboost abort <task_name>\x1b[0m     Prune worktree and discard changes
  \x1b[36mboost test\x1b[0m                  Run polyglot test suite in the current directory
`);
    break;
}
