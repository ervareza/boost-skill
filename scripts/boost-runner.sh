#!/usr/bin/env bash
# ==============================================================================
# boost-runner.sh - Automated Worktree Lifecycle & Auto-Healing Orchestrator
# Part of Boost Skill (https://github.com/ervareza/boost-skill)
# Author: Ervareza Naurian (@ervareza)
# ==============================================================================

set -eo pipefail

ACTION="${1:-help}"
BOOST_NAME="${2:-}"

# Ensure inside a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ [Boost] Error: Not inside a Git repository!" >&2
    exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
WORKTREES_ROOT="$REPO_ROOT/.worktrees"

# Validate or generate safe task name
if [ -z "$BOOST_NAME" ]; then
    BOOST_NAME="boost-$(date +%s)-$RANDOM"
fi

# Invariant: Prevent path traversal and enforce safe alphanumeric + dash/underscore
if [[ ! "$BOOST_NAME" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || [[ "$BOOST_NAME" =~ \.\. ]]; then
    echo "❌ [Boost] Error: Invalid task name '$BOOST_NAME'. Allowed: [A-Za-z0-9._-], no path traversal." >&2
    exit 1
fi

WORKTREE_DIR="$WORKTREES_ROOT/$BOOST_NAME"
# Resolve absolute canonical directory path
RESOLVED_PATH="$(cd "$REPO_ROOT" && mkdir -p .worktrees && cd .worktrees && pwd)/$BOOST_NAME"
if [[ "$RESOLVED_PATH" != "$WORKTREES_ROOT/$BOOST_NAME" ]]; then
    echo "❌ [Boost] Security error: Worktree path escapes .worktrees directory!" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$ACTION" in
    init)
        echo "🚀 [Boost] Initializing isolated ephemeral worktree: $WORKTREE_DIR"
        
        # Check if worktree or branch already exists
        if [ -d "$WORKTREE_DIR" ]; then
            echo "⚠️  [Boost] Worktree directory $WORKTREE_DIR already exists."
            exit 0
        fi

        if git show-ref --quiet --heads "$BOOST_NAME"; then
            echo "❌ [Boost] Error: Git branch '$BOOST_NAME' already exists. Use a unique task name." >&2
            exit 1
        fi

        mkdir -p "$WORKTREES_ROOT"
        git worktree add -b "$BOOST_NAME" "$WORKTREE_DIR"
        
        # Initialize Boost metadata
        cat << EOF > "$WORKTREE_DIR/.boost-manifest.json"
{
  "task_id": "$BOOST_NAME",
  "base_branch": "$(git rev-parse --abbrev-ref HEAD)",
  "base_sha": "$(git rev-parse HEAD)",
  "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "verified": false
}
EOF
        echo "✅ [Boost] Worktree ready at: $WORKTREE_DIR"
        echo "👉 Cd into worktree and perform multi-agent changes: cd $WORKTREE_DIR"
        ;;

    verify)
        if [ ! -d "$WORKTREE_DIR" ]; then
            echo "❌ [Boost] Worktree directory $WORKTREE_DIR does not exist!" >&2
            exit 1
        fi
        echo "🧪 [Boost] Running physical verification inside $WORKTREE_DIR..."
        
        # Find verification engine
        VERIFIER=""
        if [ -f "$WORKTREE_DIR/scripts/boost-verify.sh" ]; then
            VERIFIER="$WORKTREE_DIR/scripts/boost-verify.sh"
        elif [ -f "$SCRIPT_DIR/boost-verify.sh" ]; then
            VERIFIER="$SCRIPT_DIR/boost-verify.sh"
        elif command -v boost-verify &>/dev/null; then
            VERIFIER="$(command -v boost-verify)"
        fi

        if [ -z "$VERIFIER" ]; then
            echo "❌ [Boost] boost-verify.sh not found!" >&2
            exit 1
        fi

        pushd "$WORKTREE_DIR" > /dev/null
        if bash "$VERIFIER"; then
            echo "🎉 [Boost] Physical verification SUCCESS (100% PASS)"
            # Update verification stamp
            if [ -f ".boost-manifest.json" ]; then
                python3 -c "
import json
try:
    with open('.boost-manifest.json', 'r') as f:
        d = json.load(f)
    d['verified'] = True
    d['verified_at'] = '$(date -u +"%Y-%m-%dT%H:%M:%SZ")'
    d['verified_sha'] = '$(git rev-parse HEAD 2>/dev/null || echo "uncommitted")'
    with open('.boost-manifest.json', 'w') as f:
        json.dump(d, f, indent=2)
except Exception:
    pass
" 2>/dev/null || true
            fi
            popd > /dev/null
            exit 0
        else
            echo "💥 [Boost] Physical verification FAILED. Needs auto-healing round." >&2
            popd > /dev/null
            exit 1
        fi
        ;;

    reconcile)
        if [ ! -d "$WORKTREE_DIR" ]; then
            echo "❌ [Boost] Worktree directory $WORKTREE_DIR does not exist!" >&2
            exit 1
        fi

        echo "📦 [Boost] Reconciling verified changes from $BOOST_NAME into current branch..."
        TARGET_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
        
        # Safety gate: verify state
        pushd "$WORKTREE_DIR" > /dev/null
        if [ -n "$(git status --porcelain)" ]; then
            echo "  ↳ Staging uncommitted changes in worktree..."
            git add .
            git commit -m "feat(boost): verified changes for $BOOST_NAME"
        fi
        popd > /dev/null

        echo "🔄 [Boost] Merging branch $BOOST_NAME into $TARGET_BRANCH..."
        git merge "$BOOST_NAME" --no-edit

        echo "🧹 [Boost] Cleaning up ephemeral worktree and branch..."
        git worktree remove "$WORKTREE_DIR" --force
        git branch -D "$BOOST_NAME" 2>/dev/null || true
        echo "✨ [Boost] Task $BOOST_NAME successfully reconciled & clean!"
        ;;

    abort)
        echo "🛑 [Boost] Aborting and pruning worktree $WORKTREE_DIR..."
        if [ -d "$WORKTREE_DIR" ]; then
            git worktree remove "$WORKTREE_DIR" --force 2>/dev/null || {
                # Safe cleanup: only remove if strictly inside WORKTREES_ROOT
                case "$WORKTREE_DIR" in
                    "$WORKTREES_ROOT"/*) rm -rf "$WORKTREE_DIR" ;;
                    *) echo "❌ Security check failed: $WORKTREE_DIR is outside $WORKTREES_ROOT" >&2; exit 1 ;;
                esac
            }
        fi
        git branch -D "$BOOST_NAME" 2>/dev/null || true
        echo "🧹 [Boost] Cleaned up."
        ;;

    *)
        echo "Usage: $0 {init|verify|reconcile|abort} [task_id]"
        exit 1
        ;;
esac
