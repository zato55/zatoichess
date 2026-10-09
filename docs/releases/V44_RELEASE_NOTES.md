# ZATO Chess V44 Release Notes

## V44 — Tournament Replay Tie-break + History + Access Hardening

### Added
- Explicit tournament tie-break mode at creation:
  - `seed`: lower tournament seed advances immediately on draw.
  - `replay`: draw creates a dedicated tie-break room for the same two players.
- Replay tie-break persistence:
  - `tiebreak_room_code`
  - `tiebreak_game_id`
  - existing `tie_break` / `winner_reason` fields reused for auditability.
- If the replay game is also drawn, seed-based resolution remains the deterministic final fallback.
- Tournament history API: `/api/tournaments/history`.
- Social tournament history panel.
- Tournament creation UI selector for tie-break mode.
- Tournament room authorization now rejects non-participants attempting to join as players.
- Dedicated indexes for replay-game and replay-room lookups.

### Preserved
- 4/8 player single-elimination brackets.
- Tournament notifications, browser push, spectator mode.
- Arena, Cup, season, matchmaking, social, rating and game systems.

### Validation
- Dependency-free V44 structural regression.
- SQLite migration/idempotency smoke test.
- ZIP integrity check.
- Full npm/Vite build not run because project dependencies/types are not installed in this environment.
- Production Cloudflare deployment/smoke not performed.

### Known limitations
- Replay tie-break games currently pass through the normal ELO/season accounting pipeline.
