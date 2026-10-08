# ZATO Chess V74 Release Notes

## Signed Replay Bundle Verification
- Replay bundle SHA-256 verification endpoint.
- Optional HMAC-SHA256 signing using configured export secret/key id.

## Snapshot Diff History
- Contract matrix diff history is persisted with integrity hash.

## Retention Action Audit
- Retention error actions now form a per-error hash chain.

## Cleanup Replay
- Owner-only deterministic dry-run for evidence, snapshot, diff and signature retention candidates.
- No deletion occurs during replay.

## Validation
- V74 regression
- SQLite migration/idempotency/data-preservation
- ZIP integrity
- Full Cloudflare/browser production validation remains environment-dependent.
