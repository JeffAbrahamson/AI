# AI

Skills, configuration, and utilities for AI coding assistants.

Primary targets: [Claude Code](https://claude.ai/code) and [Codex CLI](https://github.com/openai/codex).

## Structure

- `skills/` — Skills installed to each agent's skills directory
- `claude/` — Claude Code-specific configuration (status line, etc.)

## Install

```sh
make install
```

Runs `make test`, then installs:

- `skills/*` → `~/.claude/skills/` and `~/.codex/skills/`
- `claude/statusline.sh` → `~/.claude/statusline.sh`

To install for a specific agent only:

```sh
make install AGENTS=claude
make install AGENTS=codex
```

## Skills

| Skill | Description |
|-------|-------------|
| `git-commit` | Stage and commit changes following project conventions |

## Jeff Doctor

`jeff-doctor.md` is a standalone best-practices checklist distilled
from the `AGENTS.md`/`CLAUDE.md` files across Jeff's other repos
(environment detection, testing discipline, git hygiene, commit
message format, pre-commit code review, style, and documentation
upkeep). It's not installed anywhere — it's meant to be referenced
directly from any other project to have an agent audit that project's
conventions and practice against it.

To run it against the project you're currently working in, reference
the file by path in your prompt, e.g. in Claude Code:

```
@/path/to/this/repo/jeff-doctor.md
```

or in Codex CLI, just point the agent at the file and ask it to follow
the instructions inside (e.g. `Read and follow
/path/to/this/repo/jeff-doctor.md`). The agent reads the checklist,
compares it against the current project's instructions and actual
practice, and reports back a conformity summary with concrete gaps to
fix — it does not modify anything on its own.
