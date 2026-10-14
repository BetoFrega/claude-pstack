# pstack on Claude Code

The pstack plugin is installed. Its skills were written for Cursor. When a pstack skill, playbook, or agent names a Cursor primitive, use the Claude Code equivalent below.

| Cursor (in the skill text) | Claude Code |
|---|---|
| `Task` subagent / Task call | `Agent` tool |
| `subagent_type: generalPurpose` / `general-purpose` | `subagent_type: "general-purpose"` |
| `subagent_type: "poteto-agent"` | `subagent_type: "pstack:poteto-agent"` |
| `readonly: true` | `subagent_type: "Explore"` when the job is pure search; otherwise `general-purpose` with "read-only: do not edit files" in the prompt |
| `run_in_background: true` / `is_background` | `run_in_background: true` on `Agent` (the default) |
| `environment: "cloud"` | not available; run locally, or use `isolation: "worktree"` when workers would collide on files |
| `model: <slug>` | `model: "opus"`, `"sonnet"`, `"haiku"` or `"fable"`; omit to inherit |
| grok / gpt / gemini slugs | not available here; substitute a Claude model (code delegates → `sonnet` or inherit, judgment and prose → `opus`) |
| reasoning budget (`-xhigh`, `-max`) | the `effort` param on `Agent`, only when the user configured one in `~/.claude/pstack-models.md` |
| `AskQuestion` | `AskUserQuestion` |
| `CreatePlan` / `SwitchMode` to plan | `EnterPlanMode` / `ExitPlanMode` |
| todo list | the task/todo tool this session offers, otherwise a short checklist in the reply |
| `Shell`, `StrReplace`, `SemanticSearch`, `ReadLints` | `Bash`, `Edit`, `Grep`/`Glob` or an `Explore` agent, the project's linter via `Bash` |
| always-applied rule (`.mdc`) | `~/.claude/pstack-models.md`, injected below at session start when it exists |
| `~/.cursor/projects/` transcripts | `~/.claude/projects/` (`*.jsonl`) |
| `/add-plugin`, Cursor docs links, Cursor Automations | not applicable; skip or explain the gap |

Slash commands are namespaced: `/pstack:poteto-mode`, `/pstack:setup-pstack`, `/pstack:poteto-help`, and so on. Bare `/poteto-mode` in the skill text means the same skill.
