## Description

<!-- Provide a concise description of what this PR does and why. -->

## Type of Change

- [ ] 🆕 New source adapter
- [ ] 🔧 Schema change (non-breaking — new optional field)
- [ ] 💥 Breaking schema change (requires version bump)
- [ ] 🐛 Bug fix
- [ ] ✨ New feature
- [ ] 📝 Documentation update
- [ ] 🔨 Infrastructure / CI change
- [ ] ♻️ Refactor (no functional change)

## Related Issues

<!-- Link any related GitHub issues: Closes #123 -->

## Changes Made

<!-- Bullet list of specific changes. -->

- 

## Schema Changes (if applicable)

- [ ] Schema version bumped (if breaking change)
- [ ] `docs/01-architecture/SYSTEM_CONTRACT.md` updated
- [ ] HubSpot property mappings updated in `schemas/crm/hubspot_mapping.v1.json` (if CRM-related)
- [ ] Example added/updated in schema file

## Source Registry (if adding a new source)

- [ ] Source registered in `seed/source-registry/source_registry.csv`
- [ ] Adapter code implemented and tested
- [ ] Smoke test added to `crawler-smoke.yml`

## Testing

- [ ] Unit tests pass locally (`npm test`)
- [ ] Smoke tests pass (`crawler-smoke.yml`)
- [ ] Tested against Supabase staging environment
- [ ] HubSpot activation tested against sandbox portal

## Security Checklist

- [ ] No secrets committed to source code
- [ ] New environment variables documented in `integrations/railway/ENVIRONMENT_CONTRACT.md`
- [ ] Outbound requests use HTTPS only
- [ ] Rate limiting considered for any new crawler

## Screenshots / Evidence

<!-- Add screenshots, logs, or Supabase query results that demonstrate the change works. -->

---

> **Reviewer:** Please verify that all checked boxes above match actual evidence in the diff.
