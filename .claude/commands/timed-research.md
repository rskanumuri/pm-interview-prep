---
description: "Launch a time-boxed background research agent that writes findings incrementally. Usage is /timed-research topic [10m]."
---

# /timed-research — Time-Constrained Background Research

Usage: `/timed-research <topic> [time]`

Examples:
- `/timed-research snowflake competitors 10m`
- `/timed-research databricks products 5m`
- `/timed-research "market sizing cloud data warehouses" 15m`

Default time: 10 minutes.

---

## Instructions

You are launching a timed background research agent. Follow these steps exactly:

### 1. Parse Arguments

Extract from `$ARGUMENTS`:
- **topic**: everything before the last token (if last token matches time pattern)
- **time**: last token if it matches `\d+m` (e.g., `10m`, `5m`). Default: `10m`

Convert time to seconds (e.g., `10m` → `600`).

### 2. Determine Output Path

Sanitize the topic into a filename:
- Lowercase, replace spaces with underscores, remove special chars
- Output path: `interview_prep/research/<sanitized_topic>.md`
- Create the `interview_prep/research/` directory if it doesn't exist

### 3. Set Timeout

Run this bash command BEFORE launching the agent:
```
mkdir -p interview_prep/research && echo <seconds> > "${TMPDIR:-/tmp}/claude_agent_next_timeout"
```

The SubagentStart hook will pick this up and apply it to the next agent spawned. The hook reads from the same `${TMPDIR:-/tmp}` location, so the writer and reader stay aligned regardless of platform.

### 4. Launch Agent

Use the Agent tool with these parameters:
- `run_in_background: true`
- `subagent_type: "general-purpose"`
- `model: "sonnet"`
- `description: "Timed research: <topic>"`

The agent prompt MUST include this preamble:

```
Write your output file to <output_path> right after your first round of research,
then keep enriching it as you learn more. You can be stopped at any point, and the
file must always hold your best work so far, so a complete file beats a perfect one.

Your time budget: <time>. Work efficiently.

---

Research topic: <topic>

Research checklist:
1. Company overview & recent news
2. Key products and competitive positioning
3. Financial data (revenue, growth, funding)
4. Leadership and org structure
5. Strategic initiatives and market trends
6. Relevant connections to the user's background (from CLAUDE.md)

Write findings to: <output_path>
```

### 5. Confirm to User

After launching, tell the user:
```
Launched timed research: "<topic>"
⏱ Auto-stops after: <time>
📄 Output: <output_path>
```

Do NOT wait for the agent to finish. The background notification system handles that.
