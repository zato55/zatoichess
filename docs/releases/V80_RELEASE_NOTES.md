# ZATO Chess V80 Release Notes

## Verification-chain export
- Key audit chain export with SHA-256 and optional HMAC-SHA256 signature.
- Server-side chain verification with failure diagnostics and head hash.

## Policy and cleanup integrity
- Policy drift alert audit read model.
- Cleanup replay comparison with integrity hash.
- Retention policy consistency history.

## Validation
- V80 regression.
- SQLite migration/idempotency/data-preservation fixture.
- ZIP integrity.

## Limitations
- No live Cloudflare/D1/browser production deployment validation in this environment.
- Existing inherited Worker parser/build limitations remain documented in continuation context.
