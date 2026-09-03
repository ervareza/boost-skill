#!/usr/bin/env bash
# ==============================================================================
# boost-runner.sh - Automated Worktree Lifecycle & Auto-Healing Orchestrator
# Part of Boost Skill (https://github.com/ervareza/boost-skill)
# Author: Ervareza Naurian
# ==============================================================================

set -eo pipefail

ACTION="${1:-help}"
BOOST_NAME="${2:-boost-task-$(date +%s)}"
WORKTREE_DIR=".worktrees/$BOOST_NAME"

case "$ACTION" in
    init)
        echo "🚀 [Boost] Initializing isolated ephemeral worktree: $WORKTREE_DIR"
        mkdir -p .worktrees
        git worktree add -b "$BOOST_NAME" "$WORKTREE_DIR"
        echo "✅ [Boost] Worktree ready at: $WORKTREE_DIR"
        echo "👉 Cd into worktree and perform multi-agent changes: cd $WORKTREE_DIR"
        ;;

    verify)
        if [ ! -d "$WORKTREE_DIR" ]; then
            echo "❌ [Boost] Worktree directory $WORKTREE_DIR does not exist!"
            exit 1
        fi
        echo "🧪 [Boost] Running physical verification inside $WORKTREE_DIR..."
        pushd "$WORKTREE_DIR" > /dev/null
        
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        if "$SCRIPT_DIR/boost-verify.sh"; then
            echo "🎉 [Boost] Physical verification SUCCESS (100% PASS)"
            popd > /dev/null
            exit 0
        else
            echo "💥 [Boost] Physical verification FAILED. Needs auto-healing round."
            popd > /dev/null
            exit 1
        fi
        ;;

    reconcile)
        echo "📦 [Boost] Reconciling verified changes from $BOOST_NAME into current branch..."
        TARGET_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
        
        pushd "$WORKTREE_DIR" > /dev/null
        if [ -n "$(git status --porcelain)" ]; then
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
            git worktree remove "$WORKTREE_DIR" --force 2>/dev/null || rm -rf "$WORKTREE_DIR"
        fi
        git branch -D "$BOOST_NAME" 2>/dev/null || true
        echo "🧹 [Boost] Cleaned up."
        ;;

    *)
        echo "Usage: $0 {init|verify|reconcile|abort} [task_id]"
        exit 1
        ;;
esac
