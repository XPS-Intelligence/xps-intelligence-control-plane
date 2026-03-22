# OpenAI GPT Actions Schema Contract

## Action types
- read
- write
- command

## Rules
- All writes must go through governed APIs.
- No uncontrolled production writes.
- No fabricated endpoints.
- Every action surface must be auditable.
- Admin-only commands must be behind explicit approval boundaries.

## Planned capabilities
- trigger manual scraper
- trigger scheduled scraper
- read leads
- read lead details
- request enrichment
- read analytics/stats/charts
- trigger approved admin functions
