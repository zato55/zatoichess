# ZATO Chess V33 — Competitive Seasons + Rank Tiers

- Added quarter-based competitive seasons through `GET /api/season`.
- Added rating-based rank tiers: Bronze, Silver, Gold, Platinum, Diamond, Master, Grandmaster.
- Leaderboard entries now expose tier metadata.
- Player profiles expose tier metadata and the current season summary.
- Season stats include games, W/D/L, win rate, starting rating, peak rating and rating delta.
- Added V33 indexes for finished-game and rating-history queries.
- No historical backfill is required; season statistics are derived from existing `games` and `rating_history` data.
- Version: 33.0.0
