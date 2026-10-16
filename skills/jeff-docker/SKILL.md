---
name: jeff-docker
description: Audit a project's Docker development setup against Jeff's current docker-template repository and propose prioritised updates with an implementation plan. Use for a Jeff Docker audit or review of docker/ best practices.
---

# Jeff Docker

Audit the current project's Docker development setup, in the same spirit
as Jeff Doctor: report conformity and propose a plan. Do not modify the
project or template unless the user also asks for implementation.

## Read the live reference

Use `~/src/jma/docker-template/` (normally
`/home/jeff/src/jma/docker-template/`) as the source of current practices.
Read it at invocation time; do not rely on installed template copies or
remembered conventions. If it is unavailable, ask for its location and
do not claim to have audited against the current template.

Check the reference checkout's branch, commit, and working-tree status.
Fetch `origin` and compare `HEAD` with `origin/main`. Warn prominently
if the checkout differs, has local changes, or freshness cannot be
verified. Do not reset, switch branches, or discard local edits; state
which version the report actually uses.

Read its `AGENTS.md`, `CLAUDE.md`, `README.md`, and `BEST-PRACTICES.md`.
Inspect `docker/` to understand how the guidance is implemented. Read
the relevant files in `skills/update-docker-manage/references/` and
`bash/docker-manage-rc.sh` when needed to assess a specific workflow.
Derive the audit criteria from these live sources rather than treating
this skill as a second copy of their recommendations.

## Compare with the target project

Read the target project's agent instructions, `docker/`, other relevant
Docker/Compose files, build/test runners, CI configuration, runtime
version files, and dependency locks. Establish what its commands
actually do, including custom targets and dependencies.

Compare relevant practices with evidence from both repositories.
Distinguish an actual gap from an intentional project adaptation.
Preserve runtime requirements, custom commands, ports, mounts, and
service dependencies in the proposed plan. Do not recommend wholesale
template replacement or importing another project's stack.

If the project has no `docker/`, report that and assess its existing
container setup or whether introducing one would help. Mark irrelevant
practices explicitly as not applicable rather than inventing work.

Keep the audit read-only. Do not build images, run project workflows,
start or stop containers, or invoke an implementation skill merely to
produce the report. Identify the verification needed for implementation.

## Report and implementation plan

Keep the report concise and evidence-based:

1. Identify the target project and the reference path, commit, and any
   freshness warnings.
2. For each relevant practice, report **Met / Partial / Missing / Not
   applicable**, with a concrete target file/line or command definition
   and the reference file supporting the assessment.
3. Propose prioritised updates. Explain each gap's practical impact and
   why its priority is justified; omit cosmetic churn and unsupported
   recommendations. Say explicitly if no worthwhile updates are found.
4. End with an ordered implementation plan: affected files, changes to
   make, dependencies between steps, customisations to preserve, and
   validation commands with expected outcomes. Include migration or
   cleanup implications where relevant. Distinguish planned checks from
   checks actually performed; do not present unrun tests as passing.

The report and plan are the deliverable. Implement only when asked.
