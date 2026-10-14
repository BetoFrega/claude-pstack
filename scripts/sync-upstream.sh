#!/usr/bin/env bash
# Vendors poteto's pstack from cursor/plugins into plugins/pstack and rewrites
# Cursor-specific paths and subagent names for Claude Code.
# Usage: scripts/sync-upstream.sh [git-ref]   (default: main)
set -euo pipefail

REF="${1:-main}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$REPO_ROOT/plugins/pstack"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

git clone --quiet --depth 1 --branch "$REF" --filter=blob:none --sparse \
  https://github.com/cursor/plugins.git "$WORK/plugins"
git -C "$WORK/plugins" sparse-checkout set pstack
SRC="$WORK/plugins/pstack"
COMMIT="$(git -C "$WORK/plugins" rev-parse HEAD)"
VERSION="$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' "$SRC/plugin.json" | head -1)"

for dir in skills agents docs assets; do
  rm -rf "${DEST:?}/$dir"
  cp -R "$SRC/$dir" "$DEST/$dir"
done
cp "$SRC/LICENSE" "$DEST/LICENSE"
cp "$SRC/README.md" "$DEST/UPSTREAM_README.md"

# Path and name rewrites. Longest patterns first.
find "$DEST/skills" "$DEST/agents" "$DEST/docs" -type f \( -name '*.md' -o -name '*.sh' -o -name '*.tsv' \) -print0 |
  xargs -0 perl -pi -e '
    s#~/\.cursor/rules/pstack-models\.mdc#~/.claude/pstack-models.md#g;
    s#`pstack-models\.mdc`#`pstack-models.md`#g;
    s#\.cursor-plugin/plugin\.json#.claude-plugin/plugin.json#g;
    s#~/\.cursor/plugins/#~/.claude/plugins/#g;
    s#~/\.cursor/skills/#~/.claude/skills/#g;
    s#~/\.cursor/projects/#~/.claude/projects/#g;
    s#\$HOME/\.cursor/projects/#\$HOME/.claude/projects/#g;
    s#(?<![\w~/])\.cursor/skills/#.claude/skills/#g;
    s#subagent_type: generalPurpose#subagent_type: general-purpose#g;
    s#`generalPurpose`#`general-purpose`#g;
    s#subagent_type: "poteto-agent"#subagent_type: "pstack:poteto-agent"#g;
  '

# Keep plugin version in lockstep with upstream.
perl -pi -e "s/\"version\": *\"[^\"]*\"/\"version\": \"$VERSION\"/" \
  "$DEST/.claude-plugin/plugin.json" "$REPO_ROOT/.claude-plugin/marketplace.json"

printf '%s\n%s\n' "$COMMIT" "$VERSION" > "$DEST/UPSTREAM_COMMIT"
echo "pstack $VERSION synced from cursor/plugins@$COMMIT"
