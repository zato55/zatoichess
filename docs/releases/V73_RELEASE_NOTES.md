# ZATO Chess V73 — Release Notes

## Scope
- Versioned public-share contract-matrix snapshots with SHA-256 integrity.
- Verification incident audit export with integrity metadata.
- Retention-error acknowledgement/resolution/reopen lifecycle.
- Deterministic replay bundle aggregating matrix snapshots, verification incidents, retention errors and replay comparisons.

## Security
- Owner-only endpoints.
- Exports are private/no-store.
- No IP, User-Agent, fingerprint or visitor identity is persisted.
- Export integrity uses canonical JSON + SHA-256.

## Validation
- V73 regression: PASS.
- SQLite migration/idempotency/data-preservation validation: PASS.
- ZIP integrity: PASS.
- Full production Cloudflare/D1/browser validation: not available in this environment.
