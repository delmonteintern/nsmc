#!/bin/bash
# Installs the global Claude Code tools that don't live in this repo
# (GSD and the agent-browser CLI) when a cloud session starts.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# GSD installs into ~/.claude, so it is gone in every fresh container.
if [ ! -f "$HOME/.claude/skills/gsd-help/SKILL.md" ]; then
  npx --yes @opengsd/gsd-core@latest --claude --global
fi

if ! command -v agent-browser >/dev/null 2>&1; then
  npm install -g agent-browser
fi

# Chrome downloads are blocked by the network policy; reuse the preinstalled Chromium.
if [ -x /opt/pw-browsers/chromium ] && [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo 'export AGENT_BROWSER_EXECUTABLE_PATH=/opt/pw-browsers/chromium' >> "$CLAUDE_ENV_FILE"
fi
