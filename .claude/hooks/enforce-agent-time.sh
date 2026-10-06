#!/bin/bash
# Hook: PreToolUse — enforces a per-subagent time limit.
# No node dependency: the JSON payload is parsed with sed. State files live in
# $TMPDIR when set, falling back to /tmp; override TMPDIR for non-MSYS environments.
#
# Behavior after the limit: tool calls are blocked (exit 2) EXCEPT up to GRACE_WRITES
# Write/Edit calls, so a timed-out agent can still save its findings. Blocking every
# call (the old behavior) also blocked the final write and lost the work.
TMP="${TMPDIR:-/tmp}"
GRACE_WRITES=3
INPUT=$(cat)

jget() { printf '%s' "$INPUT" | sed -n 's/.*"'"$1"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1; }

AGENT_ID=$(jget agent_id)

# Root agent or unparseable payload: allow (a parse failure must never block work)
[ -z "$AGENT_ID" ] && exit 0

START_FILE="${TMP}/claude_agent_${AGENT_ID}_start"
TIMEOUT_FILE="${TMP}/claude_agent_${AGENT_ID}_timeout"
GRACE_FILE="${TMP}/claude_agent_${AGENT_ID}_grace"

# No start file means no tracking: allow
[ ! -f "$START_FILE" ] && exit 0

START_TIME=$(cat "$START_FILE")
MAX_SECONDS=$(cat "$TIMEOUT_FILE" 2>/dev/null || echo 3600)
ELAPSED=$(( $(date +%s) - START_TIME ))

if [ "$ELAPSED" -gt "$MAX_SECONDS" ]; then
  TOOL=$(jget tool_name)
  case "$TOOL" in
    Write|Edit)
      USED=$(cat "$GRACE_FILE" 2>/dev/null || echo 0)
      if [ "$USED" -lt "$GRACE_WRITES" ]; then
        echo $((USED + 1)) > "$GRACE_FILE"
        exit 0
      fi
      ;;
  esac
  echo "Agent time limit exceeded: $((ELAPSED / 60))m of $((MAX_SECONDS / 60))m allowed. Stop researching. Save your findings to the output file with Write now (a few final writes are allowed), then finish." >&2
  exit 2  # BLOCK
fi

exit 0
