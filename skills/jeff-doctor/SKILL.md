---
name: jeff-doctor
description: Audit the current project's agent instructions and practice against Jeff's cross-project engineering and AI-agent conventions in jeff-doctor.md, and report conformity with a prioritised plan. Use for a Jeff Doctor audit.
---

# Jeff Doctor

Audit the current project against the live checklist in
`~/src/jma/AI/jeff-doctor.md` (normally
`/home/jeff/src/jma/AI/jeff-doctor.md`). Read it at invocation time. Do
not rely on a copy, on this skill's wording, or on remembered
conventions; the checklist is the only source of the audit criteria.
If the file is unavailable, ask for its location and do not claim to
have run the audit.

## Check the checklist's freshness first

Before auditing, check the `AI` clone that contains the file, using
`git -C` rather than `cd`:

```sh
git -C ~/src/jma/AI fetch origin
git -C ~/src/jma/AI status --short --branch
git -C ~/src/jma/AI rev-parse HEAD origin/main
```

Warn prominently, at the top of the report, if the clone is not on
`main`, if `HEAD` differs from `origin/main` (ahead, behind, or
detached), if the working tree has local changes, or if the fetch
fails so that freshness cannot be confirmed. State which commit the
report used. Do not reset, switch branches, pull, or discard changes to
fix this.

## Run the audit

Read `jeff-doctor.md` in full and follow its "What to do" section
against the current project. Keep the audit read-only: propose changes,
and make them only if the user asks.
