"""Render the mechanical sections of story_bank.md from story_bank.json.

Usage (from the repo root):
    python -X utf8 tools/gen_story_bank_md.py            # print sections to stdout
    python -X utf8 tools/gen_story_bank_md.py --check    # compare Quick Index with story_bank.md

This prints what comes straight from the JSON: the Quick Index, the told and
score lists, the never-told list, tested angles by company, and the Health
Warnings (stored in the JSON under "health_warnings"). The
judgment sections of story_bank.md (By Question Type, By Company prose,
Performance Dashboard wording) are written by /story-bank refresh. The script
never writes a file.
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BANK = ROOT / "interview_prep" / "story_bank.json"
MD = ROOT / "interview_prep" / "story_bank.md"
ORDER = {"needs_work": 0, "strong": 1}


def origin(story):
    year = str(story.get("year", "")).strip()
    short = re.sub(r"\b20(\d\d)\b", r"\1", year)
    company = str(story.get("company_origin", "")).strip()
    return f"{company} '{short}" if short else company


def quick_index(stories):
    ranked = sorted(enumerate(stories), key=lambda p: (ORDER.get(p[1]["performance"].get("status"), 2), p[0]))
    rows = []
    for n, (_, s) in enumerate(ranked, 1):
        perf = s["performance"]
        rows.append(
            f"| {n} | {s['name']} | {origin(s)} | {s.get('headline_number', '')} | "
            f"{perf.get('status', '')} | {perf.get('times_told', 0)} |"
        )
    return rows


def scores(story):
    return [i["score"] for i in story["performance"].get("interviews", []) if i.get("score") is not None]


def main():
    data = json.loads(BANK.read_text(encoding="utf-8"))
    stories = data["stories"]
    rows = quick_index(stories)

    if "--check" in sys.argv:
        md_rows = [l.strip() for l in MD.read_text(encoding="utf-8").splitlines() if re.match(r"^\| \d+ \|", l)]
        diffs = [(a, b) for a, b in zip(rows, md_rows) if a != b]
        if len(rows) != len(md_rows):
            print(f"row count differs: json {len(rows)}, md {len(md_rows)}")
        for a, b in diffs:
            print("json:", a)
            print("md:  ", b)
        print("Quick Index matches." if not diffs and len(rows) == len(md_rows) else f"{len(diffs)} row(s) differ.")
        md_text = MD.read_text(encoding="utf-8").replace("\r\n", "\n")
        missing = [w["id"] for w in data.get("health_warnings", [])
                   if f"{w['id']}. {w['text']}".split("\n")[0] not in md_text]
        print("Health Warnings match." if not missing else f"Health Warnings differ from the JSON: {missing}")
        return 0 if not diffs and len(rows) == len(md_rows) and not missing else 1

    meta = data.get("metadata", {})
    print(f"> JSON last_updated: {meta.get('last_updated')} | {len(stories)} stories | Scores on a 1-5 scale\n")
    print("## Quick Index\n")
    print("| # | Story | Origin | Key Number | Status | Told |")
    print("|---|-------|--------|------------|--------|------|")
    print("\n".join(rows))
    print("\n(needs_work and strong sorted to top; remainder in bank order.)\n")

    print("## Computed lists (for the Performance Dashboard)\n")
    told = sorted(stories, key=lambda s: -s["performance"].get("times_told", 0))
    print("- **Most told:** " + "; ".join(
        f"{s.get('short_name') or s['name']} x{s['performance']['times_told']}"
        for s in told if s["performance"].get("times_told", 0) >= 3))
    scored = [(min(scores(s)), max(scores(s)), s) for s in stories if scores(s)]
    print("- **Lowest single score per story:** " + "; ".join(
        f"{s.get('short_name') or s['name']} {lo}" for lo, _, s in sorted(scored, key=lambda t: t[0])[:6]))
    print("- **Highest single score per story:** " + "; ".join(
        f"{s.get('short_name') or s['name']} {hi}" for _, hi, s in sorted(scored, key=lambda t: -t[1])[:6]))
    never = [s for s in stories if s["performance"].get("times_told", 0) == 0 and s.get("company_angles")]
    print("- **Never told live despite company angles:** " + ", ".join(
        s.get("short_name") or s["name"] for s in never))
    tested = {}
    for s in stories:
        for company, angle in (s.get("company_angles") or {}).items():
            if isinstance(angle, dict) and angle.get("tested") not in (False, None, "No"):
                tested.setdefault(company, []).append(
                    f"{s.get('short_name') or s['name']} ({angle.get('tested')}, {angle.get('score')})")
    print("\n## Tested angles by company (for By Company)\n")
    for company in sorted(tested):
        print(f"- **{company}:** " + "; ".join(tested[company]))

    print("\n## Health Warnings\n")
    for w in data.get("health_warnings", []):
        print(f"{w['id']}. {w['text']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
