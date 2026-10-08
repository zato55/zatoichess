# ZATO Chess V70 — Release Notes

## Scope
- Retention execution telemetry for public-share contract evidence.
- Verification history for contract-summary and key-chain checks.
- Route-matrix aggregation for deterministic contract replay evidence.
- Owner-only route-matrix JSON export with SHA-256 integrity metadata.
- Owner Share Health UI for verification history and route matrix.
- Evidence retention execution is persisted with status/error count.

## Data retention
- Contract evidence: 90 days.
- Contract replay summaries: 180 days.
- Key audit chain: 365 days.
- Verification history: 365 days.

## Validation
- `V70 regression OK`
- SQLite V70 migration/idempotency fixture: verified.
- ZIP integrity: verified.
- Full TypeScript/Vite production build remains unavailable because the inherited Worker parser/dependency limitations from earlier releases are still present.
