# ZATO Chess V25 — Match Results + Rematch

- Finished online games now emit persistent `game_result` notifications to both players.
- Result notification writes are idempotent via `game_results_notified`.
- Added `rematch_requests` D1 table with 10-minute expiry.
- Added `/api/games/:id/rematch`, `/api/rematches`, `/api/rematches/respond`.
- Rematch is restricted to the finished game's two players who are still accepted friends.
- Accepted rematches reuse a private room code and open the online room flow.
- Social notification center now surfaces rematch requests.
- V25 package version: 25.0.0.
