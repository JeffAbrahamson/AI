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
