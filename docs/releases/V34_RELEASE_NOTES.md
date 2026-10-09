
# ZATO Chess V34 — Seasonal Competitive Snapshots
- Added D1 `season_player_stats` for persistent per-season rating snapshots and W/D/L stats.
- Completed games now update seasonal start/current/peak rating and rating delta atomically with normal Elo history.
- Added `/api/season/leaderboard` with seasonal rank and promotion/demotion presentation.
- `/api/season` now exposes seasonal rank and projected tier movement.
- Social UI now shows the seasonal leaderboard and promotion/demotion state.
- Added `db/migrations/V34.sql` and canonical schema entries.
- Version: 34.0.0
