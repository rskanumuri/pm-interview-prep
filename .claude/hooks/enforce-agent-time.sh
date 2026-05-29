#!/bin/bash
# Hook: PreToolUse — blocks tool calls after elapsed time exceeds limit
# Requires `node` on PATH (used to parse the JSON hook payload). State files live in
# $TMPDIR when set, falling back to /tmp; override TMPDIR for non-MSYS environments.
TMP="${TMPDIR:-/tmp}"
INPUT=$(cat)
AGENT_ID=$(echo "$INPUT" | node -e "let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>{try{console.log(JSON.parse(d).agent_id||'root')}catch{console.log('root')}})")

# Skip if not a subagent
[ "$AGENT_ID" = "root" ] && exit 0

START_FILE="${TMP}/claude_agent_${AGENT_ID}_start"
TIMEOUT_FILE="${TMP}/claude_agent_${AGENT_ID}_timeout"

# No start file means no tracking — allow
[ ! -f "$START_FILE" ] && exit 0

START_TIME=$(cat "$START_FILE")
MAX_SECONDS=$(cat "$TIMEOUT_FILE" 2>/dev/null || echo 1800)
ELAPSED=$(( $(date +%s) - START_TIME ))

if [ $ELAPSED -gt $MAX_SECONDS ]; then
  echo "Agent time limit exceeded: $((ELAPSED / 60))m of $((MAX_SECONDS / 60))m allowed" >&2
  exit 2  # BLOCK
fi

exit 0
