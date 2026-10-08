# ZATO Chess Project Context — V66

## Current source of truth
V66 is the current source of truth. V65 is the immediate parent.

## Architecture
- Frontend: React + TypeScript + Vite (`src/App.tsx`, `src/styles.css`)
- Backend: Cloudflare Worker (`worker/index.ts`)
- Durable Objects: ROOMS, SOCIAL, MATCHMAKING
- Database: Cloudflare D1 (`db/schema.sql`, `db/migrations/`)
- Chess: chess.js + local Stockfish 19
- Auth: `zato_session` HttpOnly cookie + D1 sessions

## V66 focus
- Runtime public-share route/cache contract fixtures.
- Deterministic 200 → 304 → 200 replay for public HTML, tournament JSON, replay JSON and OG SVG.
- Key-rotation lifecycle verification harness.
- Persistent D1 contract replay and key-rotation run records.
- Documentation standard: all release/checklist/continuation notes live under `docs/`.

## Share security/analytics retained
- Tokenized public shares with expiration, privacy, revoke and rotation.
- SHA-256 token storage; optional HMAC-SHA256 export signing.
- Privacy-safe aggregate views, cache analytics, abuse telemetry and alert history.
- Conditional ETag caching with `x-zato-cache: origin-miss` / `conditional-hit`.
- Maintenance replay, audit and retention diagnostics.

## Known limitations
- No real Cloudflare/D1/CDN/browser production execution is available in this environment.
- Historical Worker TypeScript parser errors remain inherited from pre-V62 source; do not claim a clean full build until repaired.
- Static/deterministic contract harnesses are not a substitute for deployed route smoke tests.

## Validation completed for V66
- `V66 regression OK`
- `V66 runtime route/cache replay OK`
- `V66 key rotation lifecycle OK`
- migration/idempotency/data-preservation replay
- ZIP integrity + SHA-256

## Next logical V67
- Worker-compatible runtime contract execution fixtures.
- Known-vector HMAC signature verification.
- Persistent contract-run dashboard/failure history.
- Migration forward/rollback compatibility matrix.

## Continuation rule
Every future ZIP must include this continuation context under `docs/continuation/`, release notes and production checklist under `docs/releases/`, and a clear next-chat continuation point.
