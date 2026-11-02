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

## Commit conventions

The former `git-commit` skill has been retired. Commit conventions
live in the **Commit messages** section of [jeff-doctor.md](jeff-doctor.md).
Remove any previously installed `git-commit` directories from
`~/.claude/skills/` and `~/.codex/skills/`; `make install` does not
remove retired skills.

## Jeff Docker

The `jeff-docker` skill audits a project's Docker development setup
against the live `~/src/jma/docker-template/` repository. It reads the
current best practices and implementation, reports conformity, and
proposes prioritised updates with an implementation and validation plan.
It does not change the audited project unless asked.

Install with `make install`, then invoke `/jeff-docker` in Claude Code
or `$jeff-docker` in Codex from the project to audit.

## Blog post

The `blog-post` skill drafts or improves a post for the blog and
LinkedIn from a draft and supporting documents, mainly on mobility and
nonprofit governance, or discusses a draft's argument and style before
it becomes a post. It examines the argument and evidence before the
prose, researches factual claims independently, challenges the author
where useful, and writes the post in French by default as `<slug>.md`
(blog) and `<slug>.txt` (LinkedIn, plain text, at most 3,000
characters). It also writes `<slug>-research.md`, with each claim's
research status and citations, and gives editorial notes, verification
notes, and a justified visual choice. The research behind its style
code, with sources and limits, is in
`skills/blog-post/references/evidence.md`.

Install with `make install`, then invoke `/blog-post` in Claude Code
or `$blog-post` in Codex, giving the draft and, where useful, whether
you want discussion or a post, the audience, intended effect, speaking
role (personal or association, with any CA statement), points that
must remain, and supporting documents.

## Jeff Doctor

`jeff-doctor.md` is a standalone best-practices checklist distilled
from the `AGENTS.md`/`CLAUDE.md` files across Jeff's other repos
(environment detection, testing discipline, git hygiene, commit
message format, pre-commit code review, style, and documentation
upkeep). It's not installed anywhere — it's meant to be referenced
directly from any other project to have an agent audit that project's
conventions and practice against it.

Its primary audience is always *other* repos — when editing the
checklist, keep it self-contained and stack-agnostic, and don't let it
assume anything about this AI repo's own structure or tooling. (It's
fine, and expected, for the same general guidelines to also hold up
here; that's just a side effect of them being good guidelines, not the
point of the file.)

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
