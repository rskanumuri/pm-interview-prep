#!/bin/bash
# Hook: SubagentStop — cleans up temp files when agent finishes
# Requires `node` on PATH (used to parse the JSON hook payload). State files live in
# $TMPDIR when set, falling back to /tmp; override TMPDIR for non-MSYS environments.
TMP="${TMPDIR:-/tmp}"
INPUT=$(cat)
AGENT_ID=$(echo "$INPUT" | node -e "let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>{try{console.log(JSON.parse(d).agent_id||'none')}catch{console.log('none')}})")

rm -f "${TMP}/claude_agent_${AGENT_ID}_start"
rm -f "${TMP}/claude_agent_${AGENT_ID}_timeout"

exit 0
