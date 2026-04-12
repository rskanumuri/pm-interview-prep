# Research — Deep Company & Market Research Agent

Launches background research for company deep-dives, competitive analysis, market sizing, and product teardowns. Runs asynchronously so the user can keep prepping while research completes.

## Purpose

Formalizes the research pattern: launch research, get results, save to cheat sheet.

## Multi-Role File Keying

When saving research output keyed by company, follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". Accept an optional `<role>` arg; when provided, research files save as `{company}_{role_slug}_research.md`, else fall back to `{company}_research.md` (legacy single-role). Read-order on lookups: try role-keyed first, fall back to company-only.



Parse `$ARGUMENTS` to determine the command:

### `<company>` — Full Company Deep Dive

Launch a comprehensive research sweep using WebSearch and WebFetch:

**Research Checklist:**
1. **Company basics**: Revenue, ARR, growth rate, headcount, funding stage, key execs
2. **Product portfolio**: All products, how they work, pricing model, target customer
3. **Competitive landscape**: Top 3-5 competitors, differentiation, market position
4. **Recent news**: Last 90 days of press releases, earnings, product launches, layoffs
5. **Technology stack**: What they build with, open-source contributions, technical blog posts
6. **Culture signals**: Glassdoor themes, engineering blog tone, values/mission statement
7. **Role-specific**: What the team you're interviewing for actually does day-to-day

**Output:** Save to `interview_prep/insights/{company}.md` (create or update).

Format:
```markdown
# {Company} — Research Brief
**Last updated:** {date}
**Sources:** {list of URLs consulted}

## Company Overview
{revenue, stage, headcount, key metrics}

## Product Portfolio
{each product: what it does, who uses it, pricing}

## Competitive Landscape
| Competitor | Differentiation | Your Angle |
|------------|----------------|------------|
| {name} | {how they differ} | {how your experience maps} |

## Recent News (Last 90 Days)
- {date}: {headline} — {relevance to interview}

## Technology & Architecture
{tech stack, infrastructure decisions, open-source, technical culture}

## Culture & Values
{mission, values, interview culture, what they look for}

## Role Intelligence
{what the team does, recent hires, team size, reporting structure}

## Questions You Should Ask
1. {intelligent question based on research}
2. {question}
3. {question}
```

### `<company> pricing` — Pricing Deep Dive

Focused research on:
- Current pricing model (public pricing pages)
- Pricing history (changes, controversies)
- Competitor pricing comparison
- Pricing strategy signals (PLG vs enterprise vs hybrid)
- How your pricing experience maps

Save to company cheat sheet pricing section.

### `<company> product <product_name>` — Product Teardown

Deep dive on a specific product:
- Features, UX, user reviews
- Technical architecture (if public)
- Market position vs alternatives
- Growth trajectory
- How you would improve it (for product sense interviews)

### `<company> competitors` — Competitive Analysis

Build a detailed competitive matrix:
- Feature comparison
- Pricing comparison
- Market share estimates
- Recent wins/losses
- Technical differentiation

### `market <topic>` — Market Research

General market research on a topic (e.g., "cloud game streaming", "legal AI", "fraud detection"):
- Market size and growth
- Key players
- Trends and disruptions
- Where your experience fits

## Execution Strategy

1. Use WebSearch for initial discovery
2. Use WebFetch to pull specific pages for detail
3. Cross-reference multiple sources for accuracy
4. Save everything with source URLs
5. After saving, auto-commit and push

## Key Rules

- Always cite sources with URLs
- Don't fabricate market data — if uncertain, say "estimated" or "industry reports suggest"
- Prioritize RECENT data (last 12 months)
- When research is for an interview within 48 hours, flag urgent findings
- After saving to insights file, offer to update the company cheat sheet too
- If the company already has research, UPDATE don't overwrite — add new findings, keep existing
