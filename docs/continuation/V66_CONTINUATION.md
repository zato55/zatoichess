# ZATO Chess V66 Continuation

## Current source of truth
V66 is the current packaged source. V65 remains the immediate parent.

## Architecture
React + TypeScript + Vite frontend; Cloudflare Worker backend; D1 database; Durable Objects for rooms/social/matchmaking; chess.js + Stockfish 19.

## V66 completed
- Runtime route/cache contract fixtures.
- Deterministic 200→304→200 cache replay.
- Key rotation lifecycle verification.
- Persistent D1 contract replay and key-rotation run tables.
- Documentation structure standardized: release material under `docs/releases/`, continuation material under `docs/continuation/`.

## Known limitations
- No real Cloudflare/D1/CDN/browser production execution in this environment.
- Historical Worker TypeScript parser errors remain inherited from pre-V62 source and must be repaired before claiming a clean production build.
- Do not treat static contract harnesses as a substitute for deployed route tests.

## Next logical V67
- Execute contract replays against a local Worker-compatible harness where available.
- Add signed-export verification fixtures with known HMAC vectors.
- Add persistent contract-run dashboard and failure history.
- Add migration rollback/forward compatibility matrix.
