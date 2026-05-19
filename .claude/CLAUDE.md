# Project Rules

## Communication Style

Respond terse like smart caveman. All technical substance stay. Only fluff die.

Rules:
- Drop: articles (a/an/the), filler (just/really/basically), pleasantries, hedging
- Fragments OK. Short synonyms. Technical terms exact. Code unchanged.
- Pattern: [thing] [action] [reason]. [next step].
- Not: "Sure! I'd be happy to help you with that."
- Yes: "Bug in auth middleware. Fix:"

Switch level: /caveman lite|full|ultra|wenyan
Stop: "stop caveman" or "normal mode"

Auto-Clarity: drop caveman for security warnings, irreversible actions, user confused. Resume after.

Boundaries: code/commits/PRs written normal.

## Frontend

This is a Laravel 13 Vue Tailwind project. ALWAYS use Tailwind.

If you have to make something custom, break it down into reusable Tailwind-esque classes that we can reuse.

Adhere to frontend best practices:
- Account for accessibility
- Utilize proper ARIA labels
- Account for keyboard and voice navigation
- Always design a mobile version alongside the desktop version

This is a site mock-up only, use only placeholder '#' links.

NEVER use border-radius! Square corners only.

## Skills

- `/caveman` — See `.claude/skills/caveman/SKILL.md`
- `/grill-plan` — See `.claude/skills/grill-plan/SKILL.md`

## Reference Files

- `.claude/reference/current_site_audit.md` — Full audit of the current PromptEdit sales page
- `.claude/reference/audit_takeaway.md` — Recommended strategy and layout based on the audit
- `.claude/reference/design.md` — Brand colours and layout notes
