# V54 — Share Abuse Telemetry + Cache-Aware Accounting + Route Health

## Added
- Rate-limit bucket abuse telemetry: blocked request count + last blocked timestamp.
- Owner-only `/api/tournaments/:id/share/health` diagnostics.
- Cache-aware public share view accounting: 304 responses do not increment views.
- Public share JSON ETag is based on tournament content, not mutable view counters.
- Public replay keyboard controls: Left/Right and Space autoplay toggle.
- Worker version/readiness upgraded to 54.0.0.
- Route simulation regression tooling.

## Security
- No IP, User-Agent or visitor fingerprint is stored.
- Health endpoint exposes only aggregate counters to the authenticated tournament owner.
- Public share/replay access remains token + visibility + expiration + rate-limit gated.

## Validation
- `node scripts/regression-v54.mjs`
- `node --check scripts/regression-v54.mjs`
- V54 SQLite migration/idempotency contract test
- Full npm/Vite build not run because dependencies are unavailable in the environment.
