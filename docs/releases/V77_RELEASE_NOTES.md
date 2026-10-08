# V77 Release Notes

## Key Chain Verification
- Owner-only key audit chain verification endpoint.
- Persistent verification history with failure index/reason.

## Snapshot Diff
- Deterministic comparison of two contract-matrix snapshots.
- SHA-256 integrity and persistent diff history.

## Policy Drift
- Retention policy drift check and history.
- Detects deviations in evidence/summary/key-chain/verification retention windows.

## Validation
- V77 regression.
- SQLite migration/idempotency/data preservation.
- ZIP integrity.

Full Cloudflare/D1/browser production deployment validation remains environment-dependent.
