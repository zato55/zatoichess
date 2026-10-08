# ZATO Chess V67 Release Notes

## Focus
Contract replay evidence, key rotation audit continuity, deterministic maintenance replay runs.

## Changes
- Added D1 evidence rows for public share route contract replays.
- Added owner-only key rotation audit endpoint.
- Added owner-only maintenance replay run history endpoint.
- Added persisted replay hashes and deterministic-run markers.
- Bumped package/readiness/export version to 67.0.0/v67.
- Kept visitor/IP/User-Agent/fingerprint data out of the new telemetry.
- Preserved the `docs/releases` and `docs/continuation` project-note layout.

## Validation
- V67 regression
- Contract evidence replay fixture
- Deterministic maintenance replay fixture
- SQLite migration/idempotency/data-preservation validation
- ZIP integrity

## Known limitations
The inherited Worker TypeScript parser errors from V62 remain; V67 does not claim a full production build. Cloudflare/D1/CDN/browser production validation still requires the real deployment environment.
