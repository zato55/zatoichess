# ZATO Chess V75 Release Notes

## Scope
Signed replay-bundle verification history, matrix diff drill-down support, retention audit verification, cleanup replay history and retention policy consistency.

## Backend
- `tournament_share_replay_bundle_verifications`
- `tournament_share_cleanup_replay_history`
- `tournament_share_retention_policy_checks`
- Owner-only verification history endpoint.
- Owner-only bundle integrity verification endpoint.
- Cleanup replay history endpoint with SHA-256 integrity.
- Retention policy consistency check endpoint.

## Frontend
- Share Health V75 operations panel.
- Bundle verification history.
- Cleanup replay integrity/history.
- Retention policy consistency action.

## Validation
- V75 regression.
- SQLite migration/idempotency/data preservation.
- ZIP integrity.
- Full production Cloudflare/D1/browser deployment validation remains unavailable in this environment.
