# V76 Release Notes

## Scope
- Active/retired signing-key aware replay-bundle verification.
- Persistent V76 verification history.
- Versioned replay-bundle export with SHA-256 integrity.
- Retention policy check history.
- Owner Share Health V76 verification panel.

## Security
- Verification requires the configured key id to be active.
- HMAC-SHA256 is checked against the canonical payload SHA-256.
- Exports are owner-only and `private, no-store`.
- No visitor IP, User-Agent or fingerprint is persisted.

## Validation
- V76 regression: PASS.
- SQLite migration/idempotency/data preservation: PASS.
- ZIP integrity: PASS.
- Real Cloudflare/D1/browser production deployment validation is not available in this environment.
