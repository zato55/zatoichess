# ZATO Chess V31 — Game Analytics + Leaderboard Filters

- Added persisted `loss_cp` to Stockfish analysis records.
- Game detail now exposes ACPL, estimated accuracy, analyzed move count and classification counts.
- Added lightweight opening recognition from saved SAN moves with common ECO families.
- Leaderboard now supports `scope=global|friends` and optional `timeControl` filtering.
- Added D1 migration `db/migrations/V31.sql`; apply it before deploying the V31 Worker to an existing database.
- Existing V18–V30 social, push, rematch, rating-history and profile systems remain compatible.
- Version: 31.0.0

## Deployment note
V31 requires the `analyses.loss_cp` column. Run the migration against the existing D1 database before enabling the new analysis endpoint in production.
