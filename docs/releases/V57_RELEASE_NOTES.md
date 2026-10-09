# ZATO Chess V57 — Public Share Retention, Aggregation & Cache Diagnostics

## Delivered
- Added `tournament_share_audit_daily` for privacy-safe daily aggregation of share lifecycle events.
- Scheduled Worker cleanup now aggregates the recent audit window and removes raw audit rows older than 90 days.
- Owner Share Health exposes 30-day aggregated audit counts in addition to recent raw audit events.
- Standardized `x-zato-cache` diagnostics across public HTML, tournament JSON, replay JSON and OG SVG routes:
  - `origin-miss` on origin 200 responses
  - `conditional-hit` on 304 responses
- OG SVG conditional 304 now uses the same cache diagnostic contract as HTML/JSON/replay.
- Deterministic integration regression verifies 200→304 view accounting and audit aggregation semantics.
- System/readiness/status version is `57.0.0` and V57 migration marker is included.

## Privacy / security
- No IP, User-Agent, fingerprint, or visitor identity is added.
- Raw share audit records are retained for 90 days; daily aggregates remain available for operational reporting.
- Existing public token, visibility, expiration, revocation and 60/minute per-token rate limiting rules remain unchanged.

## Validation
- `node --check scripts/regression-v57.mjs` — OK
- `node scripts/regression-v57.mjs` — `V57 public-share retention/cache integration regression OK`
- SQLite migration/idempotency via Python sqlite3 — `V57 sqlite migration/idempotency OK`
- TypeScript check still reaches the inherited `worker/index.ts(442,1397): error TS1005: ')' expected`; this predates V57 and is not introduced here.
- Full npm/Vite build remains unavailable because project dependencies are not installed in the working environment.
- Real Cloudflare Worker/D1/CDN/browser production behavior was not validated.
