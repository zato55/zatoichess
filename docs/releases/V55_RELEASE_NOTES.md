# V55 — Share Health UX + Cache Diagnostics + Link Regeneration

## Added
- Owner-only Share Health UI in the tournament detail modal.
- Health states: healthy, throttled, private, expired, revoked, missing.
- Aggregate hourly allowed/blocked request diagnostics and 60/min rate-limit display.
- Explicit cache diagnostics for tournament JSON, replay JSON, and OG image.
- `x-zato-cache` response marker for `origin-miss` vs `conditional-hit` on cached JSON routes.
- Explicit `Yeni public link` regeneration UX; existing POST rotation semantics remain token-safe.
- Route/UI regression suite: `scripts/regression-v55.mjs`.
- Worker/system status version upgraded to `55.0.0`.
- No new database migration required.

## Hardening
- Fixed the stale duplicate ETag declaration inside `cachedJson` inherited from V54 source.
- Readiness checks include `tournament_share_abuse_windows`.
- Cache diagnostics do not expose visitor identity, IP, User-Agent, or fingerprints.

## Validation
- `node scripts/regression-v55.mjs` → `V55 route/UI regression OK`
- `node --check scripts/regression-v55.mjs` passed.
- TypeScript check remains blocked by the inherited `worker/index.ts` parser error (`TS1005: ')' expected`) in tournament-history code.
- Full npm/Vite build unavailable because dependencies are not installed.
- No real Cloudflare production/CDN/browser validation performed.
