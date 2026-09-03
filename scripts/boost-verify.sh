#!/usr/bin/env bash
# ==============================================================================
# boost-verify.sh - Universal Test & Build Verification Engine
# Part of Boost Skill (https://github.com/ervareza/boost-skill)
# Author: Ervareza Naurian
# ==============================================================================

set -eo pipefail

echo "🔍 [Boost Verify] Detecting project stack & running verification suite..."

# 1. Node.js / TypeScript (pnpm, yarn, bun, npm)
if [ -f "package.json" ]; then
    echo "📦 Stack: Node.js / TypeScript detected"
    
    # Typecheck if TypeScript is configured
    if [ -f "tsconfig.json" ]; then
        echo "  ↳ Running TypeScript Typecheck..."
        npx tsc --noEmit || { echo "❌ TypeScript typecheck failed"; exit 1; }
    fi

    # Run lint if script exists
    if grep -q '"lint"' package.json; then
        echo "  ↳ Running Linter..."
        npm run lint || { echo "❌ Lint check failed"; exit 1; }
    fi

    # Run tests
    if grep -q '"test"' package.json; then
        echo "  ↳ Running Test Suite..."
        npm test || { echo "❌ Test suite failed"; exit 1; }
    fi

    # Build check
    if grep -q '"build"' package.json; then
        echo "  ↳ Running Build Compilation..."
        npm run build || { echo "❌ Build compilation failed"; exit 1; }
    fi

    echo "✅ [Boost Verify] Node.js suite PASSED 100%"
    exit 0
fi

# 2. Python (pytest, unittest, ruff/flake8)
if [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ]; then
    echo "🐍 Stack: Python detected"
    
    if command -v pytest &>/dev/null; then
        echo "  ↳ Running pytest..."
        pytest || { echo "❌ pytest failed"; exit 1; }
    elif [ -d "tests" ]; then
        echo "  ↳ Running python -m unittest..."
        python3 -m unittest discover tests || { echo "❌ unittest failed"; exit 1; }
    fi

    echo "✅ [Boost Verify] Python suite PASSED 100%"
    exit 0
fi

# 3. Rust (cargo test & cargo check)
if [ -f "Cargo.toml" ]; then
    echo "🦀 Stack: Rust detected"
    echo "  ↳ Running cargo check..."
    cargo check || { echo "❌ cargo check failed"; exit 1; }
    echo "  ↳ Running cargo test..."
    cargo test || { echo "❌ cargo test failed"; exit 1; }
    echo "✅ [Boost Verify] Rust suite PASSED 100%"
    exit 0
fi

# 4. Go (go test)
if [ -f "go.mod" ]; then
    echo "🐹 Stack: Go detected"
    echo "  ↳ Running go test ./... ..."
    go test -v ./... || { echo "❌ go test failed"; exit 1; }
    echo "✅ [Boost Verify] Go suite PASSED 100%"
    exit 0
fi

# 5. Flutter / Dart
if [ -f "pubspec.yaml" ]; then
    echo "💙 Stack: Flutter / Dart detected"
    echo "  ↳ Running flutter analyze..."
    flutter analyze || { echo "❌ flutter analyze failed"; exit 1; }
    echo "  ↳ Running flutter test..."
    flutter test || { echo "❌ flutter test failed"; exit 1; }
    echo "✅ [Boost Verify] Flutter suite PASSED 100%"
    exit 0
fi

echo "⚠️ [Boost Verify] No recognized test runner found. Defaulting to exit 0."
exit 0
