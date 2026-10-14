#!/usr/bin/env bash
# Injects the Cursor → Claude Code translation table, the plugin root, and the
# user's pstack model config into every session.
ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

cat "$ROOT/HARNESS.md"
printf '\npstack plugin root: `%s`. The poteto-mode skill is at `%s/skills/poteto-mode/SKILL.md`; pass this absolute path to every `pstack:poteto-agent` you spawn.\n' "$ROOT" "$ROOT"

CONFIG="$HOME/.claude/pstack-models.md"
if [ -f "$CONFIG" ]; then
  printf '\n## pstack model config (%s)\n\n' "$CONFIG"
  cat "$CONFIG"
else
  printf '\nNo `%s` yet. Run `/pstack:setup-pstack` to choose models and budget; until then use the Claude substitutions above.\n' "$CONFIG"
fi
