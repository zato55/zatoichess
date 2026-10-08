# ZATO Chess V26 — PLAYER PROFILES + GAME HISTORY

- Added authenticated public player profile endpoint: `GET /api/players/:id/profile`.
- Profile includes rating, games played, wins/draws/losses and recent completed games.
- Added head-to-head statistics against the currently signed-in viewer.
- Social friend list and player search now expose a Profile action.
- Profile modal shows recent opponents, color, time control, date and result.
- Existing V25 result persistence/rematch flow remains intact.
- Updated project continuation context and version to 26.0.0.
