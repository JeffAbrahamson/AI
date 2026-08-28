# Jeff Doctor

You have been handed this file directly (not installed into the
project) so that you can evaluate the *current* project against Jeff's
cross-project engineering and AI-agent conventions, distilled from his
other repositories' `AGENTS.md`/`CLAUDE.md` files.

## What to do

1. Read this whole file.
2. Read whatever agent-instruction files already exist in the current
   project (`CLAUDE.md`, `AGENTS.md`, `.claude/`, `.codex/`, or
   equivalent), and skim enough of the actual codebase and recent git
   history to judge real practice, not just documented practice.
3. Compare both against each item in the checklist below.
4. Report back as a **conformity report**: for each checklist item,
   say Met / Partial / Missing / Not applicable, with one line of
   evidence (a file, a command, a commit) — not a restatement of the
   checklist text. Skip items that are genuinely not applicable to
   this project's language/stack, but say so explicitly rather than
   silently omitting them.
5. End with a short, prioritized list of concrete gaps worth fixing —
   things you could add to this project's `CLAUDE.md`/`AGENTS.md` or
   change in practice. Do not make changes yourself unless asked;
   propose them.

Don't pad the report. A one-line "Met" is fine when it's obviously
met.

## Checklist

### Environment detection

- If the project can run inside Docker or another container/sandbox
  with a fuller toolchain than the host, the agent instructions say
  how to tell which environment you're in (e.g. "in Docker your
  working directory is directly under `/`, like `/app`; outside
  Docker it's a deep path like `/home/...`") and require stating the
  check and its conclusion out loud before running build/test
  commands.

### Testing

- Agent instructions require running the project's real test suite
  before handing off work — not just claiming success.
- They state the exact command(s) to run, including the
  Docker/non-Docker variants if relevant.
- Agents are told they may run tests without asking permission first.
- Agents are told never to commit changes with failing tests.
- Agents are told what to do when they *can't* run tests (state that
  clearly, explain why, and ask the user to test) rather than silently
  skipping verification.
- Lint/format checks (if the project has them) are required before
  every commit, even for changes that look unrelated — they're cheap
  and catch pre-existing breakage too.

### Git hygiene

- If the project commonly uses worktrees or multiple local clones,
  instructions warn against `cd`-ing into another worktree to run git
  commands, and specifically against chaining `cd <dir> && git ...`,
  since that pattern can silently run commands against the wrong
  branch.
- Instructions state whether the agent should ask before committing,
  and under what conditions it's fine to commit autonomously (e.g.
  "the user asked for several steps including committing along the
  way"). Everyone, agent included, is expected to go through the same
  review path — no special-casing the agent's own commits.
- Destructive git operations (force-push, reset --hard, history
  rewrites, amending shared commits) are called out as requiring
  explicit user involvement.
- New files are `git add --intent-to-add`ed as soon as they're
  created, before requesting a review — so `git diff`/`git status`
  make clear to both the agent and a reviewer (human or subagent) that
  the new file exists and needs reviewing, rather than it silently
  showing up as untracked and easy to miss.

### Commit messages

- Subject line: imperative/declarative present tense, no trailing
  period, kept short (~50 characters) so it reads well in a one-line
  log.
- A blank line separates subject from body.
- Body wraps at a fixed width (~72–78 chars), except for content where
  wrapping would hurt (tables, code, URLs, stack traces).
- Body explains *why*, not what the diff already shows: motivation,
  approach taken, alternatives considered, tradeoffs, and any
  operational/migration impact.
- Real newlines are used, never literal `\n` inside a `-m` string —
  the instructions specify a heredoc or `-F` form for multi-line
  messages.
- Line lengths (subject and body wrap width) are checked *before*
  proposing the commit to a human, not after — by inspecting the
  drafted message itself, not by committing first and fixing with
  `git log`/`--amend` afterward. If the draft needs reformatting, fix
  it before it's ever committed.
- If the current branch name contains a number, instructions treat
  that as a likely issue number and say to reference it in the commit
  message (e.g. `Part of #123`) — with a reality check: a small number
  in a young repo with few issues is plausible, but the same guess is
  much less credible in a repo with high existing issue numbers or a
  long commit history, and should be treated with more suspicion (or
  skipped/asked about) in that case.
- Bullet style is specified explicitly (marker character, two-space
  indent, hanging indent, blank-line rules) so formatting is
  deterministic instead of left to taste each time.
- Each commit is one logical change; unrelated refactors, formatting,
  and behavior changes aren't bundled together.
- Issue/incident references, if used, go at the end in a consistent
  form (e.g. `Refs: #123` or `Part of #123`).
- No emojis in commit messages (unless the project explicitly wants
  them). AI co-authorship, if credited, gets one plain line, not a
  decorative footer.

### Code review before commit

- For any non-trivial change, instructions require an independent
  review pass (a reviewer subagent, `/code-review`, or equivalent)
  before proposing a commit or handing off to a human — with a
  sensible trivial-change exception (typo fixes, comment tweaks,
  one-line non-logic edits) and a rule to treat anything ambiguous as
  non-trivial.
- Instructions ask for transparency around this: a brief note when the
  review starts, that it's being waited on, and what its feedback was
  and how it was addressed — not a silent pass/fail.
- Each subagent review launch is visibly counted out loud (e.g.
  "launching a second subagent to code review"), so a human skimming
  the transcript can see how many review cycles have happened without
  reconstructing it.
- If a review returns substantive things to fix, the fix is made and
  then re-reviewed with a fresh subagent — reviews aren't treated as
  passed until a review comes back clean, with only trivial issues
  (e.g., things that won't cause breakage), or with only things
  deliberately not addressed, explained as such).
- If the review/fix cycle goes past about three rounds, instructions
  say to suspect a loop or a deeper problem rather than continuing to
  iterate indefinitely, and to ask the human for help at that point.
- Human review feedback is analyzed and acted on judgment, not
  rubber-stamped — the reviewer (human or subagent) isn't trusted to
  be right any more than the agent trusts itself; if the agent
  disagrees with a piece of feedback, it says so and explains why
  rather than silently complying or silently ignoring it.

### Style and comments

- Instructions say not to make gratuitous whitespace/formatting
  changes unrelated to the task at hand.
- Comments are expected where they add real value (why, not what) —
  not banned outright, not required everywhere.
- The project's formatter/linter config is treated as the source of
  truth for style, rather than the agent's own taste.
- Any project-specific naming or abbreviation conventions (e.g.
  spelling out an abbreviation on first use in a comment, function
  naming prefixes that encode behavior) are written down somewhere the
  agent will see them, not left to be inferred from reading code.

### File and structural conventions

- Conventions that aren't obvious from the code itself and that an
  agent could easily get wrong — file-naming schemes (especially
  anything encoding order or time, like migration filenames),
  transactional vs. non-transactional variants, required file headers
  (e.g. copyright), directory layout expectations for new code — are
  documented explicitly rather than assumed.

### Documentation upkeep

- `CLAUDE.md`/`AGENTS.md` content is kept close to what a new
  contributor (human or agent) would actually need: build/test
  commands, architecture overview, and the rules above — not a dumping
  ground for information easily derived by reading the code.
- If both `CLAUDE.md` and `AGENTS.md` exist, one clearly points at the
  other (or they're kept in sync) rather than silently diverging.

## Follow on

Expect that, after a possible conversation, the human will ask you to
present a plan to fix what you can (modulo exceptions or additions
that arose during the conversation).
