# ZATO Chess V35 — Season Lifecycle + Rewards + Safe Backfill
- Added `seasons`, `season_game_results`, and `season_rewards`.
- Added idempotent current-season backfill from completed games and rating snapshots.
- Added automatic previous-season finalization and top-3 reward records.
- Added profile `accuracyTrend` data from stored analysis loss values.
- Existing V34 seasonal leaderboard, tiers, promotion/demotion and V31 analytics remain compatible.
- Version: 35.0.0
