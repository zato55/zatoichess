# ZATO Chess V63 Release Notes

## Summary
V63 adds export signature/key rotation metadata, alert audit filtering, deterministic maintenance replay diagnostics and expanded route contract coverage.

## Changes
- Share Health export is `v63` and exposes HMAC-SHA256 signature metadata when `SHARE_EXPORT_SIGNING_SECRET` is configured.
- `SHARE_EXPORT_SIGNING_KEY_ID` identifies the active verification key and supports rotation without embedding secrets in client exports.
- Owner-only alert audit filtering endpoint supports `alert`, `action`, and bounded `limit`.
- Owner-only maintenance replay is a dry-run: it calculates retention candidates without deleting data.
- Frontend shows replay diagnostics and alert audit samples.
- V63 migration adds export-key registry and replay history tables.
- No visitor IP, User-Agent, fingerprint, or other visitor identity is stored.

## Validation
- `node scripts/regression-v63.mjs` => V63 regression OK
- SQLite migration/idempotency/data-preservation replay => OK
- Full TypeScript/Vite build remains blocked by inherited parser/dependency limitations from earlier versions.
- Real Cloudflare/D1/CDN/browser production execution is not claimed.
