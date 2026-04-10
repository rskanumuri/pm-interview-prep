#!/bin/bash
# Hook: SubagentStop — cleans up temp files when agent finishes
INPUT=$(cat)
AGENT_ID=$(echo "$INPUT" | node -e "let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>{try{console.log(JSON.parse(d).agent_id||'none')}catch{console.log('none')}})")

rm -f "/tmp/claude_agent_${AGENT_ID}_start"
rm -f "/tmp/claude_agent_${AGENT_ID}_timeout"

exit 0
