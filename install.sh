#!/usr/bin/env bash
# ==============================================================================
# Boost Skill - Universal One-Line Installer & Multi-CLI Auto-Detector
# https://github.com/ervareza/boost-skill
# Author: Ervareza Naurian
# ==============================================================================

set -eo pipefail

BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
RESET='\033[0m'

echo -e "${CYAN}"
cat << "EOF"
  ____                   _     ____  _     _ _ _ 
 | __ )  ___   ___  ___ | |_  / ___|| | _ (_) | |
 |  _ \ / _ \ / _ \/ __|| __| \___ \| |/ /| | | |
 | |_) | (_) | (_) \__ \| |_   ___) |   < | | | |
 |____/ \___/ \___/|___/ \__| |____/|_|\_\|_|_|_|
                                                  
 Multi-Agent Reasoning & Verification Protocol
EOF
echo -e "${RESET}"
echo -e "${BOLD}Universal Installer for AI Coding CLIs & Agents${RESET}"
echo -e "Engineered by ${PURPLE}Ervareza Naurian${RESET} • Inspired by ${YELLOW}Google Antigravity /boost${RESET}\n"

# Temporary extraction directory
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo -e "📦 Fetching latest Boost Skill definitions from GitHub..."
REPO_URL="https://github.com/ervareza/boost-skill.git"
git clone --depth 1 --quiet "$REPO_URL" "$TMP_DIR"

INSTALLED_COUNT=0

# 1. Hermes Agent
if [ -d "$HOME/.hermes" ] || command -v hermes &>/dev/null; then
    echo -e "  ↳ [${GREEN}FOUND${RESET}] Hermes Agent detected"
    mkdir -p "$HOME/.hermes/skills/autonomous-ai-agents/boost"
    cp "$TMP_DIR/adapters/hermes/SKILL.md" "$HOME/.hermes/skills/autonomous-ai-agents/boost/SKILL.md"
    echo -e "    ${GREEN}✓${RESET} Installed skill to ~/.hermes/skills/autonomous-ai-agents/boost/SKILL.md"
    ((INSTALLED_COUNT++))
fi

# 2. Claude Code CLI
if command -v claude &>/dev/null || [ -d "$HOME/.claude" ]; then
    echo -e "  ↳ [${GREEN}FOUND${RESET}] Claude Code CLI detected"
    mkdir -p "$HOME/.claude/skills"
    cp "$TMP_DIR/adapters/claude-code/CLAUDE.md" "$HOME/.claude/skills/boost.md" 2>/dev/null || true
    echo -e "    ${GREEN}✓${RESET} Global Claude Code adapter installed"
    ((INSTALLED_COUNT++))
fi

# 3. OpenAI Codex CLI
if command -v codex &>/dev/null || [ -d "$HOME/.codex" ]; then
    echo -e "  ↳ [${GREEN}FOUND${RESET}] OpenAI Codex CLI detected"
    mkdir -p "$HOME/.codex/rules"
    cp "$TMP_DIR/adapters/codex/CODEX.md" "$HOME/.codex/rules/boost.md" 2>/dev/null || true
    echo -e "    ${GREEN}✓${RESET} Codex CLI rules installed"
    ((INSTALLED_COUNT++))
fi

# 4. OpenCode CLI
if command -v opencode &>/dev/null || [ -d "$HOME/.opencode" ]; then
    echo -e "  ↳ [${GREEN}FOUND${RESET}] OpenCode CLI detected"
    mkdir -p "$HOME/.opencode/plugins"
    cp "$TMP_DIR/adapters/opencode/opencode.json" "$HOME/.opencode/plugins/boost.json"
    echo -e "    ${GREEN}✓${RESET} OpenCode plugin installed to ~/.opencode/plugins/boost.json"
    ((INSTALLED_COUNT++))
fi

# 5. Roo Code / Cline
if [ -d "$HOME/Library/Application Support/Code/User/globalStorage/rooveterinaryinc.roo-cline" ] || [ -d "$HOME/.config/Code/User/globalStorage/rooveterinaryinc.roo-cline" ]; then
    echo -e "  ↳ [${GREEN}FOUND${RESET}] Roo Code / Cline detected"
    echo -e "    ${GREEN}✓${RESET} Adapter available at adapters/roo-cline/.roomodes"
    ((INSTALLED_COUNT++))
fi

# 6. Global CLI Tool Installation (~/.local/bin/boost)
mkdir -p "$HOME/.local/bin"
cat << "EOF" > "$HOME/.local/bin/boost"
#!/usr/bin/env bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOST_RUNNER=""

# Check local repo scripts or fallback
if [ -f "./scripts/boost-runner.sh" ]; then
    BOOST_RUNNER="./scripts/boost-runner.sh"
elif [ -f "$HOME/.hermes/skills/autonomous-ai-agents/boost/scripts/boost-runner.sh" ]; then
    BOOST_RUNNER="$HOME/.hermes/skills/autonomous-ai-agents/boost/scripts/boost-runner.sh"
fi

if [ -z "$BOOST_RUNNER" ]; then
    # Download standalone runner if needed
    TMP_RUNNER="/tmp/boost-runner-standalone.sh"
    curl -sSL https://raw.githubusercontent.com/ervareza/boost-skill/main/scripts/boost-runner.sh -o "$TMP_RUNNER"
    chmod +x "$TMP_RUNNER"
    BOOST_RUNNER="$TMP_RUNNER"
fi

exec "$BOOST_RUNNER" "$@"
EOF
chmod +x "$HOME/.local/bin/boost"
echo -e "  ↳ [${GREEN}INSTALLED${RESET}] Universal CLI binary installed to ${CYAN}~/.local/bin/boost${RESET}"

echo -e "\n🎉 ${GREEN}${BOLD}Boost Skill Installation Complete!${RESET}"
echo -e "✨ Installed into ${BOLD}$INSTALLED_COUNT${RESET} detected AI agent environments."
echo -e "🚀 To use in any project, simply run:"
echo -e "   ${CYAN}boost init <task_name>${RESET}     - Spawn isolated worktree"
echo -e "   ${CYAN}boost verify <task_name>${RESET}   - Run test & build verification"
echo -e "   ${CYAN}boost reconcile <task_name>${RESET}- Merge verified code & cleanup\n"
echo -e "👉 Or invoke ${BOLD}/boost <prompt>${RESET} directly inside Hermes, Claude Code, Codex, or OpenCode!"
