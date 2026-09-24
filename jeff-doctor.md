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
   Where possible, CLAUDE.md and AGENTS.md should not repeat each
   other.  Things that are only sometimes necessary, such as git
   behaviour, should be pushed to separate skill files in order not to
   pollute context all the time for occasional tasks (but still
   controlled by git, if this project is git-controlled).
3. Compare both against each item in the checklist below.
4. Report back as a **conformity report**: for each checklist item,
   say Met / Partial / Missing / Not applicable, with one line of
   evidence (a file, a command, a commit) — not a restatement of the
   checklist text. Skip items that are genuinely not applicable to
   this project's language/stack, but say so explicitly rather than
   silently omitting them.
5. End with a prioritised plan of concrete gaps worth fixing —
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

### Subagents

- Instructions say when to delegate to a subagent rather than doing
  the work inline: notably when a subtask would pull a lot of
  disposable output (search results, file dumps, exploratory
  research) into the main context that isn't needed afterward, or
  when a subtask is better suited to a different model (cheaper/faster
  for a narrow, well-specified job; more capable for something hard).
- Instructions don't just say "use subagents" without criteria —
  over-delegating trivial work is its own cost (spawn overhead, lost
  shared context), so the guidance should help the agent judge when
  delegation pays off versus when doing it inline is simpler.

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

- Instructions warn against `cd`-ing into another worktree to run git
  commands, and specifically against chaining `cd <dir> && git ...`,
  since that pattern can silently run commands against the wrong
  branch. This applies even if the project has no worktrees or extra
  clones active at the moment of the audit — worktrees tend to get
  spun up ad hoc later, so the warning should be there before it's
  needed, not added retroactively once it bites someone.
- Instructions state whether the agent should ask before committing,
  and under what conditions it's fine to commit autonomously (e.g.
  "the user asked for several steps including committing along the
  way"). Everyone, agent included, is expected to go through the same
  review path — no special-casing the agent's own commits.
- Destructive git operations (force-push, reset --hard, history
  rewrites, amending shared commits) are called out as requiring
  explicit user involvement.
- Instructions say never to run `git push` in any form (including to
  the agent's own branch) unless the prompt explicitly asks for it.
  After a history rewrite, that push means a force-push, which needs
  explicit approval every time — approval for one push doesn't carry
  over to the next. An authorised force-push always means
  `git push --force-with-lease`, never bare `--force`/`-f`, so it
  fails rather than clobbering commits someone else pushed meanwhile.
- New files are `git add --intent-to-add`ed as soon as they're
  created, before requesting a review — so `git diff`/`git status`
  make clear to both the agent and a reviewer (human or subagent) that
  the new file exists and needs reviewing, rather than it silently
  showing up as untracked and easy to miss.
- Instructions remind that git and GitHub are different tools despite
  the overlap. Most work is done locally; anything interacting with
  GitHub must be specifically authorised, either by the user in the
  prompt or via a question-response that you initiate. If an operation
  can be done locally, it probably should be: for example,
  `git merge --ff-only` is almost always preferred to `gh pr merge` if
  the user requested a merge.

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
  and behaviour changes aren't bundled together.
- Issue/incident references, if used, go at the end in a consistent
  form (e.g. `Refs: #123` or `Part of #123`).
- No emojis in commit messages (unless the project explicitly wants
  them). AI co-authorship, if credited, gets one plain line, not a
  decorative footer.
- Commit messages default to British spelling (en-UK), unless the
  project's existing commit history or codebase strongly and
  consistently favours American spelling (en-US) or another language,
  in which case the agent follows that ambient convention instead.

### Code review before commit

- For any non-trivial change, instructions require an independent
  review pass (a reviewer subagent, `/code-review`, or equivalent)
  before proposing a commit or handing off to a human — with a
  sensible trivial-change exception (typo fixes, comment tweaks,
  one-line non-logic edits) and a rule to treat anything ambiguous as
  non-trivial.
- The same review procedure and thoroughness apply regardless of the
  code's origin — the agent's own work from this session, a handoff
  from another session, or code from a human or another dev that the
  agent is simply asked to review. No lighter treatment just because
  the agent trusts its own recent output.
- Instructions distinguish two points in the cycle rather than
  reviewing every edit the same way: a lighter pass during or soon
  after implementation, to catch obvious mistakes before they
  compound, and a heavier pass once the change is believed complete
  and close to hand-off. The heavier pass is where decomposing into a
  few focused subagent reviews (e.g. correctness/bugs, security,
  instruction-file compliance) run in parallel earns its cost — doing
  that on every in-progress edit instead would spend more in spawn
  overhead and re-review churn than it saves.
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
- Human review feedback is analysed and acted on judgment, not
  rubber-stamped — the reviewer (human or subagent) isn't trusted to
  be right any more than the agent trusts itself; if the agent
  disagrees with a piece of feedback, it says so and explains why
  rather than silently complying or silently ignoring it.

### Review findings quality

- Instructions say what *not* to report, so findings stay high-signal:
  pre-existing issues, anything a linter/typechecker/CI would already
  catch (the review doesn't re-run builds/tests/typecheck itself if CI
  covers that — only run them directly when the project has no CI),
  pedantic nitpicks a senior engineer wouldn't raise, issues on lines
  the change didn't touch, and issues already silenced in code (e.g. a
  lint-ignore comment). Reporting these trains the human to skim past
  future findings.
- Each finding explains its triggering condition and impact, not just
  its existence — "this could be null" isn't a finding; "this crashes
  when X, because Y" is.
- Findings are ranked by severity/confidence and cite precise
  file/line locations (plus a stable reference like a commit SHA, if
  the review is posted somewhere outside the working tree) so a human
  can jump straight to the issue instead of re-deriving it.
- Review reading is scoped to the diff plus whatever's needed to
  verify a suspected issue (surrounding implementation, tests, call
  sites, git blame/history) — not an open-ended re-audit of the whole
  codebase.
- If the review finds nothing, instructions say to state that
  explicitly.
- A review pass is read-only by default: it reports findings and
  doesn't edit code, fix issues, or commit, unless separately asked to
  — keeping "find" and "fix" as separately-judgable steps.

### Style and comments

- Instructions say not to make gratuitous whitespace/formatting
  changes unrelated to the task at hand.
- Comments are expected where they add real value (why, not what) —
  not banned outright, not required everywhere.
- The project's formatter/linter config is treated as the source of
  truth for style, rather than the agent's own taste.
- Any project-specific naming or abbreviation conventions (e.g.
  spelling out an abbreviation on first use in a comment, function
  naming prefixes that encode behaviour) are written down somewhere the
  agent will see them, not left to be inferred from reading code.
- Code comments default to British spelling (en-UK), unless the
  surrounding code/comments strongly and consistently indicate another
  language or spelling convention (e.g. an American-English codebase,
  or a codebase written in a language other than English), in which
  case the agent follows that ambient convention instead.

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

### Jeff Doctor skill

- The project has a Claude Code skill invocable as `/jeff-doctor`
  (e.g. `.claude/skills/jeff-doctor/SKILL.md`) that runs this exact
  checklist. This is Claude Code-specific convenience tooling layered
  on top of an otherwise agent-agnostic workflow: a project using a
  different agent (Codex, etc.) satisfies this item by pointing that
  agent at this file directly, per "What to do" above — the skill
  just saves Claude Code users from having to do that by hand each
  time.
- The skill reads `jeff-doctor.md` live from Jeff's `AI` repo at
  invocation time — by path, not by a copy vendored into the target
  project — so a project is always audited against whatever this file
  currently says, not whatever it said when the skill was set up.
- Before running the checklist, the skill checks whether that local
  `AI` clone is exactly `origin/main` (fetch, then compare `HEAD` to
  `origin/main`, and check for a clean working tree) and warns loudly
  if it isn't — e.g. checked out to a different branch or commit,
  ahead/behind `origin/main`, or with local edits — so a conformity
  report is never silently produced against an unreviewed or stale
  version of the checklist.
