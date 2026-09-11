#!/usr/bin/env bash
# ==============================================================================
# tests/runner.test.sh - Automated Self-Test Suite for Shiro X Dev/boost
# ==============================================================================

set -eo pipefail

BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
RESET='\033[0m'

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TEST_TMP_DIR"
}
trap cleanup EXIT

echo -e "${CYAN}${BOLD}🧪 Starting Shiro X Dev/boost Self-Verification Test Suite...${RESET}\n"

# 1. Test CLI Help & Version Output
echo -n "  ▶ [Test 1] Testing bin/boost.mjs CLI execution... "
node "$ROOT_DIR/bin/boost.mjs" help > /dev/null
echo -e "${GREEN}PASSED${RESET}"

# 2. Test Shell Scripts Syntax & Execution Flags
echo -n "  ▶ [Test 2] Testing Shell Script Syntax (bash -n)... "
bash -n "$ROOT_DIR/install.sh"
bash -n "$ROOT_DIR/scripts/boost-runner.sh"
bash -n "$ROOT_DIR/scripts/boost-verify.sh"
echo -e "${GREEN}PASSED${RESET}"

# 3. Test Worktree Isolation (init -> verify -> reconcile -> cleanup)
echo -n "  ▶ [Test 3] Testing Worktree Lifecycle in Mock Repository... "
MOCK_REPO="$TEST_TMP_DIR/mock-repo"
mkdir -p "$MOCK_REPO"
cd "$MOCK_REPO"
git init --quiet
git config user.name "Test User"
git config user.email "test@example.com"
echo "# Mock Project" > README.md
git add README.md
git commit --quiet -m "initial commit"

# Copy boost scripts into mock repo
mkdir -p "$MOCK_REPO/scripts"
cp "$ROOT_DIR/scripts/boost-runner.sh" "$MOCK_REPO/scripts/"
cp "$ROOT_DIR/scripts/boost-verify.sh" "$MOCK_REPO/scripts/"
chmod +x "$MOCK_REPO/scripts/"*.sh

# Test Init
TASK_NAME="test-boost-task-$$"
bash "$MOCK_REPO/scripts/boost-runner.sh" init "$TASK_NAME" > /dev/null
if [ ! -d "$MOCK_REPO/.worktrees/$TASK_NAME" ]; then
    echo -e "${RED}FAILED: Worktree directory not created${RESET}"
    exit 1
fi

# Add changes inside worktree
echo "export const boost = true;" > "$MOCK_REPO/.worktrees/$TASK_NAME/index.js"

# Test Reconcile
bash "$MOCK_REPO/scripts/boost-runner.sh" reconcile "$TASK_NAME" > /dev/null

if [ ! -f "$MOCK_REPO/index.js" ]; then
    echo -e "${RED}FAILED: Changes not reconciled into main branch${RESET}"
    exit 1
fi

if [ -d "$MOCK_REPO/.worktrees/$TASK_NAME" ]; then
    echo -e "${RED}FAILED: Ephemeral worktree not cleaned up after reconcile${RESET}"
    exit 1
fi
echo -e "${GREEN}PASSED${RESET}"

# 4. Test Abort Lifecycle
echo -n "  ▶ [Test 4] Testing Worktree Abort & Discard Lifecycle... "
ABORT_TASK="abort-task-$$"
bash "$MOCK_REPO/scripts/boost-runner.sh" init "$ABORT_TASK" > /dev/null
echo "trash data" > "$MOCK_REPO/.worktrees/$ABORT_TASK/trash.txt"
bash "$MOCK_REPO/scripts/boost-runner.sh" abort "$ABORT_TASK" > /dev/null

if [ -d "$MOCK_REPO/.worktrees/$ABORT_TASK" ] || [ -f "$MOCK_REPO/trash.txt" ]; then
    echo -e "${RED}FAILED: Aborted task files still exist${RESET}"
    exit 1
fi
echo -e "${GREEN}PASSED${RESET}"

# 5. Test Polyglot Verification Stack Detection
echo -n "  ▶ [Test 5] Testing Polyglot Verification Stack Detector... "
bash "$ROOT_DIR/scripts/boost-verify.sh" > /dev/null
echo -e "${GREEN}PASSED${RESET}"

echo -e "\n🎉 ${GREEN}${BOLD}All 5 Shiro X Dev/boost Verification Tests PASSED 100%!${RESET}\n"
