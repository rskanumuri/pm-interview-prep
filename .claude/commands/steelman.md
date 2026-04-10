# Steelman — Pressure Test Stories

Rigorously pressure-test interview stories against specific criteria. Finds weak links, rates survivability under 20-minute grilling, and suggests fixes.

## Data Files

- **Story Bank JSON**: `interview_prep/story_bank.json` (canonical numbers, purged stories, story inventory)
- Master Story Repository: `interview_prep/scripts/master_story_repository.md`
- Company-specific scripts: `interview_prep/scripts/{company}_*.md`
- Progress: `interview_prep/progress.json`
- Source Materials: `sources/{active_user}/` (for fact-checking)
- Proof Points: `sources/{active_user}/proof_points_by_role.md` (for company-specific signal verification)

## Commands

Parse `$ARGUMENTS` to determine the command:

### `<story_name_or_number>` — Pressure Test One Story

Deep-dive pressure test on a single story.

**Steps:**

1. Find the story in master_story_repository.md or round scripts
2. Read the full story text
3. Run the following pressure tests:

**Test 1 — Attribution Clarity (1-5)**
- Every claim uses "I" not "we" for the user's contribution
- Clear separation between what the user did vs team/leadership/org
- Flag any "we launched" or "we decided" that should be "I recommended" or "I built"

**Test 2 — Number Verification (1-5)**
- Read `canonical_numbers` from `interview_prep/story_bank.json`
- Cross-reference all numbers in the story against the canonical registry
- Flag any number that doesn't match the canonical value
- Flag any number that can't be verified from source docs
- Check for product conflation (using one product's numbers for another)

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

For each, assess whether the story has enough detail to survive.

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

Run abbreviated pressure test (Tests 1, 3, 5, 6 only) on every story in master_story_repository.md. Output a summary table.

### `round <N>` — Pressure Test a Round

Run full pressure test on all stories allocated to round N.

### `<company>` — Pressure Test Company Stories

Run full pressure test on all stories/answers for a specific company.

### `fix <story>` — Auto-Fix Flagged Issues

After a steelman run, apply the suggested fixes to the story files. Show before/after for each change. Do NOT apply without showing the user first.

## Key Rules

- Be BRUTAL but grounded in reality — don't manufacture concerns
- Always cross-reference numbers against `canonical_numbers` in `interview_prep/story_bank.json` and source docs in `sources/{active_user}/`
- Check `purged_stories` in story_bank.json — if any purged story appears ANYWHERE, flag it
- Products listed as distinct in story_bank.json must never be conflated
- Two-layer format: Layer 1 = 2-min opener, Layer 2 = deep follow-up details
- "Can AI make it faster?" test — if a generic answer could replace yours, flag it
- When suggesting fixes, provide exact replacement text, not vague guidance
