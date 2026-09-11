#!/usr/bin/env bash
# ==============================================================================
# boost-verify.sh - Universal Test & Build Verification Engine
# Part of Shiro X Dev/boost (https://github.com/ervareza/boost-skill)
# Author: Ervareza Naurian / Shiro X Dev (@ervareza)
# ==============================================================================

set -eo pipefail

BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
RESET='\033[0m'

echo -e "🔍 ${BOLD}[Shiro X Dev/boost Verify] Detecting project stack & running verification suite...${RESET}"

TOTAL_CHECKS=0
PASSED_CHECKS=0

# Helper: parse package.json scripts safely using node
has_npm_script() {
    local script_name="$1"
    node -e "
try {
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    process.exit(pkg.scripts && pkg.scripts['$script_name'] ? 0 : 1);
} catch(e) { process.exit(1); }
" 2>/dev/null
}

# 1. Node.js / TypeScript (pnpm, yarn, bun, npm)
if [ -f "package.json" ]; then
    echo "📦 Stack: Node.js / JavaScript / TypeScript detected"
    
    # Typecheck if TypeScript is configured
    if [ -f "tsconfig.json" ]; then
        echo "  ↳ Running TypeScript Typecheck..."
        ((TOTAL_CHECKS++))
        if [ -x "./node_modules/.bin/tsc" ]; then
            ./node_modules/.bin/tsc --noEmit || { echo -e "${RED}❌ TypeScript typecheck failed${RESET}"; exit 1; }
        else
            npx --no-install tsc --noEmit 2>/dev/null || npx tsc --noEmit || { echo -e "${RED}❌ TypeScript typecheck failed${RESET}"; exit 1; }
        fi
        ((PASSED_CHECKS++))
    fi

    # Run linter if script exists in scripts object
    if has_npm_script "lint"; then
        echo "  ↳ Running Linter..."
        ((TOTAL_CHECKS++))
        npm run lint || { echo -e "${RED}❌ Lint check failed${RESET}"; exit 1; }
        ((PASSED_CHECKS++))
    fi

    # Run tests if test script exists in scripts object
    if has_npm_script "test"; then
        echo "  ↳ Running Test Suite..."
        ((TOTAL_CHECKS++))
        npm test || { echo -e "${RED}❌ Test suite failed${RESET}"; exit 1; }
        ((PASSED_CHECKS++))
    fi

    # Run build if build script exists in scripts object
    if has_npm_script "build"; then
        echo "  ↳ Running Build Compilation..."
        ((TOTAL_CHECKS++))
        npm run build || { echo -e "${RED}❌ Build compilation failed${RESET}"; exit 1; }
        ((PASSED_CHECKS++))
    fi
fi

# 2. Python (pytest, unittest, ruff/flake8)
if [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ]; then
    echo "🐍 Stack: Python detected"
    
    if command -v pytest &>/dev/null && [ -d "tests" -o -d "test" ]; then
        echo "  ↳ Running pytest..."
        ((TOTAL_CHECKS++))
        pytest || { echo -e "${RED}❌ pytest failed${RESET}"; exit 1; }
        ((PASSED_CHECKS++))
    elif [ -d "tests" ]; then
        echo "  ↳ Running python3 -m unittest..."
        ((TOTAL_CHECKS++))
        python3 -m unittest discover tests || { echo -e "${RED}❌ unittest failed${RESET}"; exit 1; }
        ((PASSED_CHECKS++))
    fi
fi

# 3. Rust (cargo test & cargo check)
if [ -f "Cargo.toml" ]; then
    echo "🦀 Stack: Rust detected"
    echo "  ↳ Running cargo check..."
    ((TOTAL_CHECKS++))
    cargo check || { echo -e "${RED}❌ cargo check failed${RESET}"; exit 1; }
    ((PASSED_CHECKS++))

    echo "  ↳ Running cargo test..."
    ((TOTAL_CHECKS++))
    cargo test || { echo -e "${RED}❌ cargo test failed${RESET}"; exit 1; }
    ((PASSED_CHECKS++))
fi

# 4. Go (go test)
if [ -f "go.mod" ]; then
    echo "🐹 Stack: Go detected"
    echo "  ↳ Running go test ./... ..."
    ((TOTAL_CHECKS++))
    go test -v ./... || { echo -e "${RED}❌ go test failed${RESET}"; exit 1; }
    ((PASSED_CHECKS++))
fi

# 5. Flutter / Dart
if [ -f "pubspec.yaml" ]; then
    echo "💙 Stack: Flutter / Dart detected"
    echo "  ↳ Running flutter analyze..."
    ((TOTAL_CHECKS++))
    flutter analyze || { echo -e "${RED}❌ flutter analyze failed${RESET}"; exit 1; }
    ((PASSED_CHECKS++))

    echo "  ↳ Running flutter test..."
    ((TOTAL_CHECKS++))
    flutter test || { echo -e "${RED}❌ flutter test failed${RESET}"; exit 1; }
    ((PASSED_CHECKS++))
fi

if [ "$TOTAL_CHECKS" -gt 0 ]; then
    echo -e "🎉 ${GREEN}${BOLD}[Shiro X Dev/boost Verify] All $PASSED_CHECKS/$TOTAL_CHECKS physical verification checks PASSED!${RESET}"
    exit 0
else
    echo -e "⚠️  ${YELLOW}[Shiro X Dev/boost Verify] No automated test suites or linters found in this project.${RESET}"
    echo "👉 Recommendation: Add a test script or harness to achieve full verification confidence."
    exit 0
fi
