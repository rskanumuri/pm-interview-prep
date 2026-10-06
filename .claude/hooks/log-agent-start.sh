#!/bin/bash
# Hook: SubagentStart — logs agent start time and assigns its timeout.
# No node dependency: the JSON payload is parsed with sed. State files live in
# $TMPDIR when set, falling back to /tmp; override TMPDIR for non-MSYS environments.
#
# Timeout handoff from /timed-research: that skill APPENDS a line "<seconds> <epoch>" to
# claude_agent_next_timeout. This hook consumes the oldest line written within the last
# 300 seconds (a queue, so parallel launches each get their own value) and discards stale
# lines (so an unlaunched agent can't leak its limit onto an unrelated later agent).
TMP="${TMPDIR:-/tmp}"
DEFAULT_SECONDS=3600
FRESH_WINDOW=300
INPUT=$(cat)

jget() { printf '%s' "$INPUT" | sed -n 's/.*"'"$1"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1; }

AGENT_ID=$(jget agent_id)
[ -z "$AGENT_ID" ] && exit 0

NOW=$(date +%s)
echo "$NOW" > "${TMP}/claude_agent_${AGENT_ID}_start"

QUEUE="${TMP}/claude_agent_next_timeout"
TIMEOUT=$DEFAULT_SECONDS
if [ -s "$QUEUE" ]; then
  REMAINING=""
  PICKED=""
  while read -r SECS EPOCH; do
    [ -z "$SECS" ] && continue
    # Legacy single-number line (no epoch): treat as stale
    [ -z "$EPOCH" ] && continue
    AGE=$(( NOW - EPOCH ))
    [ "$AGE" -gt "$FRESH_WINDOW" ] && continue          # stale: drop
    if [ -z "$PICKED" ]; then PICKED="$SECS"; else REMAINING="${REMAINING}${SECS} ${EPOCH}"$'\n'; fi
  done < "$QUEUE"
  [ -n "$PICKED" ] && TIMEOUT="$PICKED"
  printf '%s' "$REMAINING" > "$QUEUE"
  [ ! -s "$QUEUE" ] && rm -f "$QUEUE"
fi

echo "$TIMEOUT" > "${TMP}/claude_agent_${AGENT_ID}_timeout"
exit 0
