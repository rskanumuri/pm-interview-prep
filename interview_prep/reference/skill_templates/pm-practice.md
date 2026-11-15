# Display layouts and templates for /pm-practice

Kept outside `.claude/commands/pm-practice.md` to keep the skill short enough to survive a context compaction. The skill points here; read the section you need when rendering. Sample values in these layouts (names, scores, dates, counts) are placeholders, not data: never copy one into output. Headings shown with a dash are written with a colon in generated files (`interview_prep/reference/skills_core.md` section 7).

---

<!-- section: Example follow-ups by gap type -->

# SECTION: Example follow-ups by gap type

### Example Follow-Ups by Gap Type

**If answer lacks metrics:**
"You mentioned the project was successful. Can you quantify that impact?"

**If answer is too "we" focused:**
"I'd love to understand your specific role. What decisions did YOU make?"

**If no tradeoffs discussed:**
"What did you have to sacrifice to make that work?"

**If missing the 'why':**
"Walk me through your reasoning for choosing that approach."

**If answer is too polished/rehearsed:**
"What was the messiest part of this project?"

**If missing reflection:**
"Looking back, what would you do differently?"

**If vague on stakeholders:**
"How did [stakeholder mentioned] react to that?"

**If timeline unclear:**
"How long did this take from start to finish?"

**For Product Sense - if missing prioritization rationale:**
"Why did you prioritize that user segment over the others?"

**For Product Sense - if missing tradeoffs:**
"What are you trading off with that solution?"

**For Product Sense - if missing metrics:**
"How would you measure if this solution is working?"

**For Strategy - if missing risks:**
"What are the biggest risks with that approach?"

**For Strategy - if missing competitive response:**
"How do you think competitors would respond?"


---

<!-- section: Answer file format -->

# SECTION: Answer file format


After each answered question, create a markdown file:

**Filename**: `interview_prep/answers/q{ID}_{company}_{date}.md`

Example: `q42_stripe_2026-02-01.md`

**Format** -- the answer file should contain these sections:

**File header:**
- `# Question {ID}: {Question Text}`
- **Company:** {Target Company}
- **Category:** {Category Name}
- **Date:** {YYYY-MM-DD HH:MM}
- **Overall Score:** {X.X}/5
- **Follow-up Mode:** {deep|light|off}

**Interview Transcript:**
- Initial Question
- My Answer (user's initial response)
- Follow-up #1, #2, #3 (if applicable) -- each with Interviewer question and My Response

**Scores:**
- Base Dimensions table (Structure, Specificity, Ownership, Reflection, Delivery -- each X/5 with brief note)
- {Company}-Specific Dimensions table (company_dim1, company_dim2, company_dim3 -- each X/5 with brief note)
- **Overall Score:** X.X/5 (average of all dimensions)

**Follow-Up Performance:**
- How well they handled probing questions
- Did they maintain composure under pressure?
- Did follow-ups reveal depth or expose gaps?

**Delivery Feedback:**
- Robotic phrases detected (list)
- Suggested rewrites: Instead of "{robotic}" -> "{natural}"

**Company-Specific Feedback:**
- How answer aligned or didn't align with company values
- Suggestions for better company fit

**Story Suggestions (Behavioral Only):**
- **Recommended story:** {Story name from STAR stories}
- **Why it fits:** {How this story demonstrates the skill being asked about}
- **Key elements to highlight:** {What parts of the story to emphasize}
- **Adaptation tip:** {How to frame it for this specific question}

**What Worked Well** -- bullet list of specific strengths

**Areas for Improvement** -- bullet list of actionable suggestions

**Key Learning** -- one main takeaway from this practice

**Revised Answer** (if applicable) -- improved version if user tried again

*Flagged for review: {Yes/No}*

**Note**: If follow-up mode was `off`, omit the follow-up sections and just include "My Answer" directly.


---

<!-- section: Hints by category -->

# SECTION: Hints by category


### Behavioral Hint

**STAR Framework:**
- **Situation:** Brief context (when, where, what was happening)
- **Task:** YOUR specific responsibility
- **Action:** What YOU did (use "I" statements, be specific)
- **Result:** Quantified impact + what you learned

**Tips:**
- Keep to 2-3 minutes
- Include specific metrics/numbers
- End with reflection/learning
- Sound conversational, not scripted!

Then ADD company-specific tips from the insights file (both `_general` and `{company}`).

### Product Sense Hint

**4-Part Framework:**
1. **MISSION & MARKET:** Start with company goal, why this problem matters
2. **USERS:** Segment users (MECE), state criteria, pick ONE to focus on
3. **PAIN POINTS:** Map their journey, identify 3+ problems, prioritize
4. **SOLUTIONS:** Brainstorm 3+ ideas, prioritize (impact vs effort), describe MVP

**Tips:**
- Always state your prioritization CRITERIA before choosing
- Use personal examples when describing pain points
- Tie solutions back to the mission
- Keep it conversational - avoid robotic transitions!

Then ADD company-specific tips (mission, products to reference, what they look for).

### Strategy Hint

**Consider:**
- Who are all the stakeholders affected?
- What metrics would you track? (leading & lagging)
- What's the competitive landscape?
- What are the tradeoffs of different approaches?
- How does this align with company mission/strategy?

Then ADD company-specific strategic context.


