---
name: commit
description: Create a git commit. Use when the user asks to commit, or when Claude has finished implementing changes and is ready to commit. Enforces project commit message conventions.
user-invocable: true
argument-hint: "[optional message hint or file]"
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git commit:*)
---

## Current State

- Status: !`git status`
- Staged and unstaged changes: !`git diff HEAD`
- Recent commits (for style reference): !`git log --oneline -5`

## Your Task

Stage appropriate files and create a single git commit following the rules below.

Never commit:
* Files that likely contain secrets (.env, credentials, private keys)
* Failing tests

If tests have not been run yet, say so and ask the user to confirm before committing.

## Commit Message Rules

### Structure

* First line: declarative summary, max 50 characters, no trailing period, imperative
  present tense ("Add", "Fix", "Refactor")
* Blank line after first line
* Body: wrap at 72 characters (except URLs, code, identifiers, stack traces)

### Body Content

The body explains the change for a future reader with no external context. Include:

* Why the change was necessary and what problem is being solved
* What approach was taken and why
* Alternatives considered (if relevant)
* Side effects, tradeoffs, operational or migration impact
* Assumptions made and known limitations or follow-ups

Do NOT merely restate what is obvious from the diff.

### Bullet Lists in Body

* Use `*`, not `-`
* Indent bullets by two spaces with hanging indent for wrapped lines
* No blank lines between single-line bullets; blank line between bullets if any wraps

### Atomicity

Each commit should represent a single logical change. Do not mix unrelated refactors
and behavior changes, formatting with functional changes, or incidental edits with
the primary purpose.

### Example

```
Add timeout to external service requests

Prevent threads from blocking indefinitely when external
services fail to respond. This reduces request pile-ups and
improves system recovery under partial outage conditions.

Timeout chosen based on 99th percentile latency observed in
production metrics.
```

## Execution

Pass the commit message via a heredoc to preserve formatting:

```bash
git commit -m "$(cat <<'EOF'
Subject line here

Body here.
EOF
)"
```

After committing, run `git status` to confirm success.
