# HM-Lens MSN: the hiring manager's real Must / Should / Nice

**Purpose:** derive what the hiring manager actually needs from a role, beyond the JD, using the product, the company's situation, the market, and why the req is open now. A JD is a negotiated document: recruiting boilerplate, a copied template, and the HM's real needs are mixed together. This method separates them.

**Used by:** `/eval` (generates it, Block G), `/fit-check` (step 0.5), `/phantom` (step 4), `/interview-prep hm` (gap analysis and problem-first play). One artifact per role, reused by every skill.

**Artifact:** `interview_prep/evaluations/{company_key}_hm_msn.md` (company_key per CLAUDE.md multi-role keying). Version it V1 (JD + public research), V2 (+ recruiter intel), V3 (+ HM intel), like `/phantom`.

---

## Hard rules

1. **No candidate data during derivation.** Don't read the user's resume, story bank, proof points or prior fit-checks while building the MSN. It describes the HM's need, not the user's fit. Fit is scored after, against the finished MSN. (Same objectivity rule as the phantom Role Taxonomy.)
2. **Role Taxonomy first.** Answer Builder or Owner, Craft or Domain, and Day-30 deliverable (see `/phantom` step 3). If any answer is ambiguous, stop and ask about the role.
3. **Every non-JD item cites evidence** (URL, or the saved intel file and line) and carries a tier:
   - **Stated:** in the JD or the HM's own public words.
   - **Inferred-strong:** 2+ independent signals point to it.
   - **Inferred-weak:** 1 signal. Never a Must.
4. **At most 4 Musts.** If everything is a Must, nothing is. A Must means: without it, the HM can't use the hire in the first 90 days, or the HM gets blamed for the hire.
5. **Every Must is falsifiable:** it names the probe the HM will use to test it and the question the candidate can ask to verify it.
6. **Doesn't change the JD score.** `/eval` Block B stays verbatim-JD. MSN is displayed beside it and raises flags; it never silently re-weights the number.
7. Public sources only for V1. No confidential employer data.

---

## Step 1: Research checklist (V1, about 15-25 min, inline WebSearch/WebFetch)

**A. JD signals (read between the lines)**
- Reports to whom (title tells the HM's charter). Team name. Level verbs ("own", "define", "drive" vs "support", "execute").
- What is conspicuously absent: a domain not asked for, a metric never named, no mention of AI in a 2026 JD.
- Repeated words (the HM's own words usually repeat). Boilerplate (copied company-wide blocks).

**B. The product in question**
- Use it if possible: free tier, trial, sandbox, public docs, pricing page, API reference, changelog, status page.
- Where it is weak: G2 / Gartner Peer Insights / Reddit / HN complaints, support forum threads, missing features vs competitors.
- Stage: 0-1, scaling, re-platform/migration, consolidation after M&A, sunset. Stage decides the Day-90 deliverable.

**C. Company situation (last 12 months)**
- Earnings or funding, growth rate trend, margin pressure, layoffs, guidance changes.
- M&A (integration work lands on PMs), exec changes (new CEO/CPO/CIO resets mandates), reorgs.
- Strategic pivots: AI mandate, platformization, pricing/GTM changes, cloud transition, IPO prep.

**D. Market**
- Top 2-3 competitors' recent moves (launches, pricing, acquisitions) that this team must answer.
- Category shift, buyer change, regulation or compliance deadline.

**D2. Stakeholder personas (added after a calibration run)**
- List who the role serves by persona: business owners (risk, sales, finance), technical builders (eng, data science), execs.
- If the role sits between business and technical personas (platform, internal tools, data, pricing), a **translation Must** is likely: explain the architecture simply to a non-technical listener, then go deep with engineers. Expect a probe like "assume I have no context, make it simple".
- If the platform's own pillars include AI (agents, foundation models, AutoML), AI fluency is at least a Should even when the JD doesn't say so.

**E. Req signals**
- Backfill or new headcount: reposting history, prior holder on LinkedIn (tenure, why left), team size.
- The HM: LinkedIn background (engineer-to-PM? sales? consultant?), posts, talks, own hiring post. The HM's own words outrank the JD.
- The HM's boss's public mandate (CEO letter, CIO talk, earnings call language).

---

## Step 2: HM synthesis (answer in 1-2 sentences each, with evidence)

1. **What problem forced this req open now?** (The trigger: migration deadline, new mandate, failed hire, acquisition, growth outpacing team.)
2. **What gets the HM promoted in 12 months?** (The outcome they will be judged on.)
3. **What failure do they fear from this hire?** (Can't ramp in the domain, needs hand-holding, wrong altitude, flight risk, breaks trust with a key stakeholder.)

The Musts fall out of these three answers, not out of the JD bullet list.

---

## Step 3: Output template

```
# HM-Lens MSN: {Company} {Role}
Version: V{n} | Built: {date} | Inputs: {JD / public research / recruiter intel / HM intel}
Role Taxonomy: {Builder|Owner} / {Craft|Domain} / Day-30: {deliverable}

## HM synthesis
- Trigger: ...
- Promotion outcome: ...
- Feared failure: ...

## Must (max 4)
| # | Must | Tier | Evidence | How the HM will test it | Verify question |

## Should (accelerates ramp; tie-breaker between finalists)
| # | Should | Tier | Evidence |

## Nice (level-up signal, never decisive)
- ...

## JD noise (in the JD, weakly weighted by the HM)
- ...

## Unwritten deal-breakers
- Domain / onsite / visa / level / comp band / clearance ...

## Day-30 and Day-90 the HM needs
- Day 30: ...
- Day 90: ...

## Confidence
{1-10}. Core assumption: "...". If wrong, {what flips}.
```

The user's fit (added by the consuming skill, never by the derivation): score the user 1-5 against each Must and Should with evidence from resume/story bank only. Any Must at 2 or below is a **HIDDEN-MUST GAP** (if the Must is not in the JD) or a **MUST GAP** (if it is). Each gap gets its verify question and a one-line bridge.

---

## Step 4: Update (V2+)

After each recruiter or HM touchpoint: mark each Must confirmed / killed / unknown, move items between tiers, add new Musts the interviewer revealed, and re-score confidence. Keep the old version's Musts in a "Changed" line so the delta is visible (it is the calibration signal).

---

## Calibration log

Blind tests: derive V1 from public sources only, then score against what the real interviews probed. Record hit rate and tune the checklist from the misses. Only test on a closed loop whose debriefs and rubrics have not been read in the session, or the test is not blind.

| Date | Role | Musts hit | False Musts | Missed Musts | Probes predicted | Tuning applied |
|---|---|---|---|---|---|---|
