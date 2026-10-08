# ZATO Chess V65 — Release Notes

## Tema
Signed export verification, signing-key rotation observability, persistent maintenance replay diffs, and route/cache contract testing.

## Yeni
- Export verify route now returns deterministic verification reasons.
- Share Health key lifecycle exposes recent key events.
- Active configured signing key cannot be retired until deployment configuration changes.
- Maintenance replay diff is persisted separately from replay payload.
- Owner-only maintenance replay history route.
- Signature rotation test harness.
- Automated route and cache-header contract matrix.
- Share Health UI shows key event history and replay history.

## Validation
- `node scripts/regression-v65.mjs` → OK
- `node scripts/signature-rotation-v65.mjs` → OK
- `node scripts/route-contract-v65.mjs` → OK
- SQLite migration/idempotency/data-preservation → OK
- Full TypeScript/Vite build: blocked by inherited parser/dependency limitations.
- Production Cloudflare/D1/CDN/browser validation: not run.
