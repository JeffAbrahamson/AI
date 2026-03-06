#!/bin/bash
# Claude Code status line
# ~/.claude/statusline.sh
# Dependencies: jq, git

# Read JSON session data from stdin
INPUT=$(cat)

# Parse session fields
MODEL=$(printf '%s' "$INPUT" | jq -r '.model.display_name // "Claude"')
PCT=$(printf '%s' "$INPUT" | jq -r '(.context_window.used_percentage // 0) | floor | tostring')
COST=$(printf '%s' "$INPUT" | jq -r '.cost.total_cost_usd // 0')
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // "."')

# Format cost as $X.XX
COST_FMT=$(awk -v c="$COST" 'BEGIN { printf "$%.2f", c }')

# Git info (run from project directory)
cd "$CWD" 2>/dev/null
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$BRANCH" ]; then
  MODIFIED=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
fi

# ANSI colors
RST='\033[0m'
DIM='\033[2m'
RED='\033[31m'
YLW='\033[33m'
GRN='\033[32m'
CYN='\033[36m'

# Context color threshold
if [ "$PCT" -ge 80 ]; then
  CTX_CLR=$RED
elif [ "$PCT" -ge 50 ]; then
  CTX_CLR=$YLW
else
  CTX_CLR=$GRN
fi

# Cost color threshold
COST_CLR=$(awk -v c="$COST" \
  -v g='\033[32m' -v y='\033[33m' -v r='\033[31m' \
  'BEGIN { if (c >= 1.0) print r; else if (c >= 0.10) print y; else print g }')

# Context progress bar (10 chars wide)
BAR_WIDTH=10
FILLED=$(( PCT * BAR_WIDTH / 100 ))
[ "$FILLED" -gt "$BAR_WIDTH" ] && FILLED=$BAR_WIDTH
EMPTY=$(( BAR_WIDTH - FILLED ))
BAR=""
for ((i=0; i<FILLED; i++)); do BAR="${BAR}█"; done
for ((i=0; i<EMPTY; i++)); do BAR="${BAR}░"; done

# Build git section
GIT_SECTION=""
if [ -n "$BRANCH" ]; then
  GIT_STR="${CYN}⎇ ${BRANCH}${RST}"
  [ "$STAGED" -gt 0 ] && GIT_STR="${GIT_STR} ${GRN}+${STAGED}${RST}"
  [ "$MODIFIED" -gt 0 ] && GIT_STR="${GIT_STR} ${YLW}~${MODIFIED}${RST}"
  [ "$UNTRACKED" -gt 0 ] && GIT_STR="${GIT_STR} ${RED}?${UNTRACKED}${RST}"
  GIT_SECTION="[${GIT_STR}] "
fi

# Assemble and print
printf "${GIT_SECTION}[${DIM}${MODEL}${RST}] [${CTX_CLR}ctx ${PCT}%% ${BAR}${RST}] [${COST_CLR}${COST_FMT}${RST}]\n"
