# ZATO Chess V42 — Tournament Brackets + Spectator Mode

## Added
- 4/8 player single-elimination tournament core.
- Tournament registration, join, start and bracket APIs.
- Dedicated room code per tournament match.
- Automatic next-round winner propagation after completed games.
- Champion + runner-up tournament rewards with idempotent inserts.
- Tournament match/game association.
- Live spectator WebSocket mode that does not consume a player slot and cannot submit moves.
- Tournament bracket UI with join/start/watch actions.
- V42 regression markers and production checklist.

## Safety / behavior
- Tournament start requires exactly the configured player count (4 or 8).
- Tournament match rooms are restricted to their two registered players unless `spectator=1`.
- Draws advance the deterministic first slot as the current tournament tie-break fallback; a future tournament rules version can replace this with an explicit rapid tie-break.
- Existing Elo, season, arena and cup flows remain unchanged.

## Validation
- SQLite schema/migration test.
- V42 structural regression test.
- Worker/TSX syntax parsing where available.
- ZIP integrity + SHA-256.
- Full production Cloudflare deployment was not performed.
