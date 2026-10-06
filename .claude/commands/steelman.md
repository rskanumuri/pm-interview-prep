---
description: "Pressure-test interview stories for attribution, numbers, opener, probe resilience, and senior-level signal."
---

# Steelman — Pressure Test Stories

Rigorously pressure-test interview stories against specific criteria. Finds weak links, rates survivability under 20-minute grilling, and suggests fixes.

## Data Files

- **Story Bank JSON**: `interview_prep/story_bank.json` (canonical numbers, purged stories, story inventory)
- Master Story Repository: `interview_prep/scripts/master_story_repository.md`
- Company-specific scripts: `interview_prep/scripts/{company}_*.md`
- Progress: `interview_prep/progress.json`
- Source Materials: `sources/{active_user}/` (for fact-checking)
- Proof Points: `sources/{active_user}/proof_points_by_role.md` (for company-specific signal verification)

## Multi-Role File Keying

When pressure-testing stories tied to a specific company+role and writing results back, follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". Accept an optional `<role>` arg; when provided, store steelman results against the role-keyed angle entries (e.g., "Stripe / ML Foundations") in master_story_repository.md.



Parse `$ARGUMENTS` to determine the command:

### `<story_name_or_number>` — Pressure Test One Story

Deep-dive pressure test on a single story.

**Steps:**

1. Find the story in master_story_repository.md or round scripts
2. Read the full story text
3. Run the following pressure tests:

**Test 1 — Attribution Clarity (1-5)**
- The user's contribution is stated as "I" with a verb that matches what he did (decided, recommended, built, aligned)
- Clear separation between what the user did vs team/leadership/org
- Flag any "we launched" or "we decided" that hides the user's part
- EXCEPTION (CLAUDE.md "match the hero to the audience"): for an engineering interviewer the team is the hero, so "I gave them the goal and constraints, they built it" is correct, not a flaw. Judge against the interviewer function the story is allocated to.
- Where ownership is contested or a platform lineage predates the user, check the ownership line in `story_bank.json` `canonical_provenance`; flag both overstated and understated claims

**Test 2 — Number Verification (1-5)** (MANDATORY in every mode, including `all`)
- Read the values from `story_bank.json` `canonical_numbers` and the meaning from `canonical_provenance`. Do not use a copy in this file.
- For each number in the story, state: value, unit/denominator ("per question", "of the 1,000+ SE population", "of about 8 pilots"), and how it was measured (measured, estimated, target). A number with no unit or no measurement basis scores WEAK even if it matches canon.
- Provenance: check the story does not break a recorded ruling in `canonical_provenance` (audience vs actual users, units and denominators, which metric a number belongs to, sample size stated, per-what baselines)
- Arithmetic: compute implied denominators and durations (percent vs count, tenure dates, any arc described as build, launch, and adoption must fit inside the stated employment window). Show the math.
- Circularity: `sources/{active_user}/` docs repeat the same claims, so agreement with them is NOT verification. A number counts as verified only if it traces to a measurement (eval set, logs, dashboard) or the user's recorded ruling. Otherwise mark it "asserted, not verified".
- Flag any number that cannot be traced, and give the probe an interviewer would use on it ("measured how, on what set, by whom?").

**Test 3 — Opener Directness (1-5)**
- First sentence MUST directly answer the question being asked
- Contains year and context (e.g., "In 2021, during the product launch...")
- Does NOT start with "we" or with what the user lacks

**Test 4 — Probe Resilience (1-5)**
Generate the 5 hardest follow-up questions an interviewer would ask:
- "You said X — but why not Y instead?"
- "What specifically did YOU do vs the team?"
- "What was the actual measurable outcome?"
- "If you knew that, why didn't you do it sooner?"
- "What happened after? Did it sustain?"

For each, assess whether the story has enough detail to survive. These five are self-generated, so grade the story's SUPPORT for an answer (is the evidence in the story or the source docs), not an imagined answer. If the support is not on the page, mark the follow-up "UNANSWERED: needs the user's answer" and do not score it as survived. Add at least one probe aimed at the weakest number from Test 2.

**Test 5 — L6/L7 Signal (1-5)**
- Does this story demonstrate senior-level ownership, strategic thinking, and cross-org influence?
- Or does it sound like an L4/L5 executing someone else's plan?
- Flag "junior signals": following orders, small scope, no ambiguity, no trade-offs

**Test 6 — Reuse Collision Check**
- Where else is this story (or its variations) used?
- Are there LP/round collisions?
- Would an interviewer in a later round hear the same story from an earlier round's feedback?

**Output:**

## STEELMAN: {Story Name}

**SURVIVABILITY SCORE:** {avg}/5.0

| Test | Score | Verdict |
|------|-------|---------|
| Attribution Clarity | X.0 | {PASS/WEAK/FAIL} |
| Number Verification | X.0 | {PASS/WEAK/FAIL} |
| Opener Directness | X.0 | {PASS/WEAK/FAIL} |
| Probe Resilience | X.0 | {PASS/WEAK/FAIL} |
| L6/L7 Signal | X.0 | {PASS/WEAK/FAIL} |
| Reuse Collision | -- | {CLEAN/COLLISION} |

---

**Hardest follow-ups (prepare for these):**
1. "{question}" -> {does story survive? what's the gap?}
2. "{question}" -> {assessment}
3. "{question}" -> {assessment}
4. "{question}" -> {assessment}
5. "{question}" -> {assessment}

**Fixes needed:**
- {specific fix with exact text change}
- {specific fix}
- {specific fix}

### `all` — Pressure Test All Stories

Run the abbreviated pressure test (Tests 1, 2, 3, 5, 6; Test 2 is never skipped) on every story in `story_bank.json`. Output a summary table. Grep for numbers first; do not read all story files in full.

### `round <N>` — Pressure Test a Round

Run full pressure test on all stories allocated to round N.

### `<company>` — Pressure Test Company Stories

Run full pressure test on all stories/answers for a specific company.

### `fix <story>` — Auto-Fix Flagged Issues

After a steelman run, apply the suggested fixes to forward-looking story files only. Show before/after for each change and wait for the user's yes. Never edit transcripts, debriefs, or files for closed companies. Fixes that need a fact the user has not supplied are listed as questions, not applied.

## Key Rules

- Be BRUTAL but grounded in reality — don't manufacture concerns
- Cross-reference numbers against `story_bank.json` canon and provenance first; `sources/{active_user}/` is supporting evidence only (see Test 2, circularity)
- Flag every entry in `story_bank.json` `purged_stories` (not just one) if it appears ANYWHERE
- Distinct products and metrics stay distinct; never conflate them (see `canonical_provenance`)
- Two-layer format: Layer 1 = 2-min opener, Layer 2 = deep follow-up
- "Can AI make it faster?" test — if a generic answer could replace the user's, flag it
- When suggesting fixes, provide exact replacement text, not vague guidance
