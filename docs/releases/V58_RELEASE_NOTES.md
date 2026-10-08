# ZATO Chess V58 Release Notes

## Share Health Alerts + Audit Trend Dashboard

Version: 58.0.0

### Delivered
- Added V58 indexes for efficient share-audit trend queries.
- Extended owner-only `/api/tournaments/:id/share/health` with:
  - 30-day daily audit trend rows
  - expiration-days calculation
  - privacy-safe alert codes
- Alert thresholds:
  - `rate-limit`: blocked public requests in the last hour
  - `expiration-soon`: share expires within 7 days
  - `private`: share is not public
  - `revoked`: share was revoked
- Added owner UI alert strip and compact 30-day lifecycle trend visualization.
- Preserved `x-zato-cache` semantics from V57; headers indicate Worker origin/conditional responses and do not claim external CDN hits.
- Added deterministic scheduled-cleanup/retention simulation to regression coverage.

### Validation
- `node scripts/regression-v58.mjs` => `V58 share-health dashboard/cleanup regression OK`
- SQLite migration/idempotency => `V58 sqlite migration/idempotency OK`
- `node --check scripts/regression-v58.mjs` => OK

### Known limitations
- Full npm/Vite build remains unavailable because dependencies are not installed in the working environment.
- TypeScript still exposes the inherited V53 parser error at `worker/index.ts(442,1397): TS1005 ')' expected`; V58 does not introduce that source issue.
- Real Cloudflare Worker/D1/CDN/browser production execution was not validated.
