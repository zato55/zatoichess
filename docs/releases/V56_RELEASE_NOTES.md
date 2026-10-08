# V56 — Public HTML Cache + Rotation Audit + Route Contracts

## Added
- Public tournament HTML share pages now support ETag/conditional GET with 60s public cache and `must-revalidate`.
- HTML `304` responses do not increment public view counters or daily analytics.
- Owner Share Health cache diagnostics now include HTML ETag caching.
- Added privacy-safe `tournament_share_audit` D1 table for share lifecycle events.
- Audit events: `created`, `rotated`, `updated`, `revoked`.
- Token regeneration logs rotation while preserving the previous token's revocation.
- Owner health response exposes the latest audit entries.
- Added `scripts/regression-v56.mjs` for public-share route contract coverage.
- Package/system version upgraded to `56.0.0`.

## Privacy / Security
- Audit data contains no IP address, User-Agent, browser fingerprint, or visitor identity.
- Public routes remain read-only and require a valid public, non-expired, non-revoked token.
- Share management and audit visibility remain owner-authenticated.

## Validation
- `node scripts/regression-v56.mjs` → `V56 public-share route contract regression OK`
- `node --check scripts/regression-v56.mjs` passed.
- SQLite migration/idempotency test → `V56 sqlite migration/idempotency OK`
- TypeScript check remains blocked by the inherited `worker/index.ts(442,1397): TS1005 ')' expected` parser error.
- Full npm/Vite build unavailable because dependencies are not installed.
- No real Cloudflare deployment/CDN/browser validation performed.
