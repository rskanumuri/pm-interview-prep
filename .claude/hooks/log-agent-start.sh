#!/bin/bash
# Hook: SubagentStart — logs agent start time and sets timeout
INPUT=$(cat)
AGENT_ID=$(echo "$INPUT" | node -e "let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>{try{console.log(JSON.parse(d).agent_id||'none')}catch{console.log('none')}})")

# Record start time
echo $(date +%s) > "/tmp/claude_agent_${AGENT_ID}_start"

# Set timeout: use pre-set value from /timed-research, or default 30 min
NEXT_TIMEOUT=$(cat /tmp/claude_agent_next_timeout 2>/dev/null || echo 1800)
echo "$NEXT_TIMEOUT" > "/tmp/claude_agent_${AGENT_ID}_timeout"
rm -f /tmp/claude_agent_next_timeout

exit 0
