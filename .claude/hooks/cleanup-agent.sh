#!/bin/bash
# Hook: SubagentStop — cleans up temp files when an agent finishes.
# No node dependency: the JSON payload is parsed with sed. State files live in
# $TMPDIR when set, falling back to /tmp; override TMPDIR for non-MSYS environments.
TMP="${TMPDIR:-/tmp}"
INPUT=$(cat)

jget() { printf '%s' "$INPUT" | sed -n 's/.*"'"$1"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1; }

AGENT_ID=$(jget agent_id)
[ -z "$AGENT_ID" ] && exit 0

rm -f "${TMP}/claude_agent_${AGENT_ID}_start" \
      "${TMP}/claude_agent_${AGENT_ID}_timeout" \
      "${TMP}/claude_agent_${AGENT_ID}_grace"

exit 0
