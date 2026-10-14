# claude-pstack

Claude Code marketplace for [pstack](https://github.com/cursor/plugins/tree/main/pstack) by Lauren Tan (poteto), MIT. Vendored from `cursor/plugins`; the commit and version are in `plugins/pstack/UPSTREAM_COMMIT`.

## Install

```bash
claude plugin marketplace add BetoFrega/claude-pstack
```

```bash
claude plugin install pstack@pstack-local
```

Then `/pstack:setup-pstack` once, and `/pstack:poteto-mode <task>` for real work. `/pstack:poteto-help` if lost.

## How the port works

- `skills/`, `agents/`, `docs/` are upstream content with mechanical rewrites only (`~/.cursor/...` paths → `~/.claude/...`, `generalPurpose` → `general-purpose`, `poteto-agent` → `pstack:poteto-agent`).
- `hooks/session-start.sh` injects `HARNESS.md` (Cursor primitive → Claude Code tool table), the plugin root path, and `~/.claude/pstack-models.md` if present. That file replaces Cursor's always-applied `pstack-models.mdc` rule.
- Non-Claude models (grok, gpt) in the defaults are substituted with Claude models. Cursor-only features (cloud subagents, Automations / Benny) have no equivalent.

## Update from upstream

```bash
scripts/sync-upstream.sh
```

```bash
claude plugin marketplace update pstack-local && claude plugin update pstack@pstack-local
```
