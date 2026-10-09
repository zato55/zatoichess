# ZATO Chess V66 Release Notes

## Focus
Runtime route/cache contract fixtures, deterministic 200→304→200 replay, key-rotation lifecycle verification, and persistent contract-run records.

## Changes
- Added V66 route/cache contract fixture set for public tournament JSON, replay JSON, OG SVG, and public HTML.
- Added deterministic runtime contract replay harness.
- Added key-rotation lifecycle verification harness.
- Added D1 tables for contract replay runs and key-rotation verification runs.
- Preserved V65 signed export, replay diff persistence, audit history, and cache diagnostics.
- Standardized project continuity/release documentation under `docs/continuation/` and `docs/releases/`.

## Validation
- `V66 regression OK`
- `V66 runtime route/cache replay OK`
- `V66 key rotation lifecycle OK`
- SQLite migration/idempotency/data-preservation test required before release packaging.
- Full production Cloudflare/D1/browser validation remains environment-dependent.
