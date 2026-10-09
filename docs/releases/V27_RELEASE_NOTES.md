# ZATO Chess V27 — MATCH HISTORY + GAME DETAIL

## Added
- Added authenticated `GET /api/games/:id` for a player's completed/owned game details.
- Game detail returns metadata, PGN, persisted moves and saved Stockfish analysis rows.
- Player profile history is now paginated with `offset`/`limit` and `hasMore`.
- Profile modal now supports loading older completed games.
- Added match detail modal with PGN, move list, result and analysis count.
- Added "Maçı tahtada aç" to load a historical game into the board.
- Added "Analizi aç" to send a historical game's moves through the existing Stockfish review flow.
- Added rematch action from historical game detail, reusing V25 rematch authorization.
- Updated package version to 27.0.0.
- Updated `ZATO_PROJECT_CONTEXT.md` with continuation state and next steps.

## Compatibility
- Existing V18–V26 social, presence, notification, rematch and profile APIs remain intact.
- Existing `games`, `moves` and `analyses` D1 tables remain the source of truth; no destructive migration was required.

## Validation
- ZIP structure checked.
- Full npm/TypeScript build depends on installed project dependencies and is not guaranteed in the current environment.
