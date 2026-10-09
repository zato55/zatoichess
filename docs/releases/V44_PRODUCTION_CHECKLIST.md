# ZATO Chess V44 Production Checklist

1. Apply `db/migrations/V44.sql` to D1.
2. Confirm `tournaments.tiebreak_mode` exists.
3. Confirm `tournament_matches.tiebreak_game_id` and `tiebreak_room_code` exist.
4. Confirm replay lookup indexes exist.
5. Deploy Worker with existing ROOMS/SOCIAL/MATCHMAKING bindings.
6. Keep Worker cron `*/5 * * * *`.
7. Create one tournament in `seed` mode and verify draw resolves immediately.
8. Create one tournament in `replay` mode and verify a drawn match creates a new tie-break room.
9. Verify only the two match players can join the tie-break room as players.
10. Verify spectators can observe the tie-break room read-only.
11. Verify a decisive replay advances the correct player.
12. Verify a second draw in replay falls back to seed and is persisted.
13. Verify tournament history lists the finished tournament and reward.
14. Verify champion/runner-up notifications remain idempotent.
15. Verify existing Elo/season/game persistence still works.
16. Keep the previous deployment available for rollback.
