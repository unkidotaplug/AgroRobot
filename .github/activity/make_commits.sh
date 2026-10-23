#!/bin/bash
# Добавляет N коммитов за указанный день в activity/log.md.
# usage: make_commits.sh <путь_к_клону> <YYYY-MM-DD> <количество_коммитов>
set -euo pipefail

REPO="$1"
DAY="$2"
COUNT="$3"

cd "$REPO"
mkdir -p activity
LOG="activity/log.md"
[ -f "$LOG" ] || echo "# Activity log" > "$LOG"

for i in $(seq 1 "$COUNT"); do
  HOUR=$(( 9 + (i * 7) % 13 ))
  MIN=$(( (i * 17) % 60 ))
  TS=$(printf "%sT%02d:%02d:00" "$DAY" "$HOUR" "$MIN")
  echo "- $TS — update $i" >> "$LOG"
  git add "$LOG"
  GIT_AUTHOR_DATE="$TS" GIT_COMMITTER_DATE="$TS" \
    git commit -q -m "activity: $DAY update $i"
done
