# Apply — Application Form Answer Generator

Generate answers for job application forms using evaluation context, resume, and story bank. Reads the form questions and produces copy-paste-ready responses tailored to the specific role.

## Data Files

### Read (always)
- Resume: `sources/{active_user}/resume.txt`
- Story Bank: `interview_prep/story_bank.json` (canonical numbers)
- CLAUDE.md: `CLAUDE.md` (career thesis, canonical numbers)

### Read (per company)
- Evaluation: `interview_prep/evaluations/{company}_*_eval.json` (cover angles from Block E, key stories from Block F)
- Company Insights: `interview_prep/insights/{company}.md`
- Cheat Sheet: `interview_prep/scripts/{company}_cheat_sheet.md`
- Applications: `interview_prep/applications.json` (current status)

### Write
- Applications: `interview_prep/applications.json` (update status to `applied` after use)

## Multi-Role File Keying

When writing application answers, follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". Accept an optional `<role>` arg; when provided, answers save as `{company}_{role_slug}_application_*.md`, else fall back to `{company}_application_*.md` (legacy single-role). Read-order on lookups: try role-keyed first, fall back to company-only.



Parse `$ARGUMENTS`:

### `<company>` — Generate Application Answers

Generate answers for common application form fields.

**Steps:**

1. **Read context:**
   - Evaluation (if exists) — use Block E cover angles and Block F key stories
   - Resume for experience details
   - Story bank for proof points
   - Cheat sheet for company-specific context

2. **If no evaluation exists:** warn and suggest running `/eval` first. Continue with generic tailoring from insights/cheat sheet.

3. **Generate answers for standard form fields:**

## APPLICATION ANSWERS — {COMPANY} — {Role Title}

---

### Why This Role? (150-300 words)

{Tailored answer connecting the user's experience to the specific role. Lead with what excites them about THIS role specifically. Reference 2-3 proof points with numbers. End with what they'd bring that's unique.}

---

### Why This Company? (150-300 words)

{Company-specific answer. Reference specific products, recent moves, or company values. NOT generic "I admire your mission" -- specific details from research/evaluation. Connect to career thesis from CLAUDE.md.}

---

### Relevant Experience (200-400 words)

{Top 3 most relevant experiences with quantified impact. Use canonical numbers from story bank. Frame each as: challenge, action, result, relevance to this role.}

---

### What Makes You a Good Fit? (150-250 words)

{Intersection positioning — where the user's unique combination of skills meets this role's needs. Reference archetype overlap. Career thesis connection if natural.}

---

### Additional Information (optional, 100-200 words)

{H1B sponsorship note if relevant. Any relevant context not captured above. Portfolio/project links if applicable.}

---

### Salary Expectations

{Based on CLAUDE.md comp targets and eval Block D research. Provide a range, not a single number. Note: "Open to discussing based on total compensation package."}

---

*Copy-paste ready. Edit to taste before submitting. Run `/save-push` to save.*

4. Offer: "Update application status to `applied`?"

---

### `<company> screenshot` — Form-Specific Answers

User provides a screenshot or paste of the actual application form.

**Steps:**

1. Ask user: "Paste the form questions or share a screenshot."
2. Read the image/text to identify each form field
3. For each field, generate a tailored answer:
   - Text fields: full written answers
   - Dropdowns: recommend the best option
   - Yes/No: answer with rationale
   - Salary: range from eval Block D / CLAUDE.md targets
   - URL fields: LinkedIn, portfolio
4. Display field-by-field answers in copy-paste format

---

### `<company> cover-letter` — Cover Letter Draft

Generate a cover letter using evaluation context.

**Steps:**

1. Read evaluation Block E (application strategy) for cover angles
2. Read resume for proof points
3. Generate 3-paragraph cover letter:
   - P1: Why this role excites the user (specific, not generic)
   - P2: Top 2-3 proof points with numbers (from story_bank.json canonical numbers)
   - P3: What the user would bring + close
4. Keep under 300 words. Conversational tone, not corporate.
5. Display and offer to save to `output/cover_letters/{company}_{date}.md`

---

## Answer Generation Rules

- **Tone: "I'm choosing you"** — Specific, confident, not desperate. The user is evaluating them too.
- **Numbers always.** Use canonical numbers from story_bank.json. Never approximate.
- **Company-specific details.** Reference their actual products, recent launches, or challenges. If you don't have specifics, say so — don't make them up.
- **Canonical numbers only.** From story_bank.json. Never approximate.
- **No hedging.** No "I believe I would be" or "I hope to." Direct: "I built X. I'd bring that to Y."
- **Pre-interview rules from CLAUDE.md apply:**
  1. Lead with business impact, not technology
  2. Never introduce with what you lack
  3. "Can AI make it faster?" test
  4. End with offer
- **Keep it human.** Short sentences. Conversational rhythm. Not resume-bullet prose.

## Integration with Other Skills

### Receives From
- `/eval` — Block E (cover angles), Block F (key stories), Block D (comp research)
- `/auto-pipe` — generates eval data that /apply consumes

### Cross-References
- "→ /eval {company}" if no evaluation exists
- "→ /save-push" to save
