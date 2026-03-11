# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```sh
make test             # Validate all skills have SKILL.md files
make install          # Run tests, then install skills and Claude statusline
make install AGENTS=claude  # Install for Claude Code only
make install AGENTS=codex   # Install for Codex CLI only
```

Install destinations:
- `skills/*` → `~/.claude/skills/` and `~/.codex/skills/`
- `claude/statusline.sh` → `~/.claude/statusline.sh`

## Architecture

This repo manages **skills** (reusable AI assistant prompts) and **configuration** for Claude Code and Codex CLI.

**Skills** (`skills/<name>/`) are prompt definitions installed to agent skill directories. Each skill requires a `SKILL.md` file — `make test` enforces this. The `SKILL.md` front matter defines the skill name, description, allowed tools, and whether it's user-invocable.

**Claude-specific config** (`claude/`) contains things like `statusline.sh`, which is copied directly to `~/.claude/`.

To add a new skill: create `skills/<name>/SKILL.md` following the format in `skills/git-commit/SKILL.md`.

## Commit Message Conventions

This repo uses strict commit message rules (enforced by the `git-commit` skill):

- Subject: imperative tense, max 50 chars, no trailing period
- Body: explain *why* the change was necessary, the approach taken, and any tradeoffs — not what the diff already shows
- Use `*` for bullets, indented two spaces with hanging indent
- Each commit is one logical change (atomic)
- Pass message via heredoc: `git commit -m "$(cat <<'EOF' ... EOF)"`
