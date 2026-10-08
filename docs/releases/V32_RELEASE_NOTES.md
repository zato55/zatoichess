# ZATO Chess V32 — Production Readiness + Analytics Trends

- Added authenticated `/api/system/status` readiness endpoint without exposing secrets.
- Added V32 D1 indexes for finished games, analysis loss lookups and rating history joins.
- Expanded common opening/ECO recognition.
- Leaderboard now supports pagination with `offset` and `hasMore` while preserving global/friends/time-control filters.
- Player recent-game records now expose per-game ACPL and analyzed move count when analysis exists.
- Existing V18–V31 social, push, rematch, rating-history and analytics systems remain compatible.
- Version: 32.0.0

## Deployment
Apply `db/migrations/V31.sql` first on existing databases, then `db/migrations/V32.sql`.
The readiness endpoint can be used after deployment to verify required D1 tables/columns and whether VAPID configuration is present; it never returns private VAPID material.
