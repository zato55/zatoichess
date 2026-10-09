# ZATO Chess V30 — Leaderboard + Rating Chart + Competitive Stats

- Added authenticated `GET /api/leaderboard` with global rating ranking and viewer rank.
- Added player profile competitive statistics: rank, win/draw rates, average opponent rating, current streak, best win streak and best loss streak.
- Expanded rating history retrieval to the latest 30 snapshots.
- Added a lightweight rating progression chart to player profiles using the existing `rating_history` data.
- Added top-10 leaderboard UI to the social panel.
- Preserved V18–V29 friend, presence, notification, push, rematch, game history and Stockfish review systems.
- No new destructive migration; V30 reuses existing D1 tables.
- Version: 30.0.0

## Validation

- Source-level route/UI checks performed.
- Full npm/TypeScript build was not run because project dependencies are not installed in the build environment.
- ZIP integrity is verified after packaging.
