# Universal Shiro X Dev/boost Adapter Contract

This directory contains the protocol contract shared by every integration.

## Adapter levels

- **Native**: the tool has a documented extension point that can express the adapter (for example, a skill, plugin, agent, workflow, or custom mode).
- **Prompt**: the tool can load instructions, but Shiro X Dev/boost orchestration is performed by the host CLI and the model follows a playbook.
- **Manual**: the tool has no verified automation hook; the user copies the prompt or runs the host commands.

Adapters must state their level honestly. A Markdown rules file cannot spawn agents, create a secure sandbox, or prove a test passed by itself.

## Required adapter behavior

Every adapter should:

1. Load the canonical protocol from `SPECIFICATION.md` or `protocol/boost.md`.
2. Tell the agent to use `boost plan`, `boost init`, `boost verify`, `boost reconcile`, and `boost abort` rather than inventing a lifecycle.
3. Preserve the host's approval gates.
4. Report the exact verification command and exit status.
5. Stop on conflicts, dirty-tree violations, missing tests, or unverifiable claims.

## Prohibited adapter behavior

- Never silently overwrite existing instruction files.
- Never claim parallel subagents when the tool is running one prompt.
- Never call `git merge`, `git push`, or destructive cleanup without the host policy allowing it.
- Never place credentials in an adapter or repository file.
