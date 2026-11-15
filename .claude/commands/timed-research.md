---
description: "Launch a time-boxed background research agent that writes findings incrementally. Usage is /timed-research topic [10m]."
argument-hint: "<topic> [10m]"
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
mkdir -p interview_prep/research && echo "<seconds> $(date +%s)" >> "${TMPDIR:-/tmp}/claude_agent_next_timeout"
```

The line is `<seconds> <epoch>` and is APPENDED (a queue): the SubagentStart hook consumes the oldest line written in the last 5 minutes, so parallel launches each get their own limit, and an unlaunched agent's line expires instead of leaking onto a later agent. Launch the agent right after this command. The hook reads from the same `${TMPDIR:-/tmp}` location, so the writer and reader stay aligned.

### 4. Launch Agent

Use the Agent tool with these parameters:
- `run_in_background: true`
- `subagent_type: "general-purpose"`
- `model`: a cheaper, faster model than the session's, if the Agent tool offers one (this is gathering work; see `interview_prep/reference/skills_core.md` §8). Pick from the model options the Agent tool lists at run time; do not rely on a name written here.
- `description: "Timed research: <topic>"`

The agent prompt MUST include this preamble:

```
Write your output file to <output_path> right after your first round of research,
then keep enriching it as you learn more. You can be stopped at any point, and the
file must always hold your best work so far, so a complete file beats a perfect one.

Your time budget: <time>. Work efficiently.

---

Research topic: <topic>

Research checklist (use the one that fits the topic; write the chosen list into the prompt):
- Company topic: overview and recent news; key products and competitive positioning; financial data (revenue, growth, funding); leadership and org structure; strategic initiatives.
- Market or concept topic: definition and scope; size and growth with sources; main players and how they differ; trends and open debates; primary sources worth reading.
- Person or team topic: public role and history; public writing or talks; what they have said about the subject at hand. Public sources only.
Every claim carries its source URL and date. Mark single-source claims as unverified. Do not add a "connections to the user's background" section; the main session does that with the story bank.

Write findings to: <output_path>
```

### 5. Confirm to User

After launching, tell the user:
```
Launched timed research: "<topic>"
⏱ Stops researching after: <time> (then it gets a few final writes to save findings, so it must write the output file EARLY and keep enriching it)
📄 Output: <output_path>
```

Do NOT wait for the agent to finish. The background notification system handles that.
