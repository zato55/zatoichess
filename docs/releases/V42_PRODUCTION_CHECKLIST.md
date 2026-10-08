# V42 Production Checklist

1. Apply `db/migrations/V42.sql` to D1.
2. Confirm `tournaments`, `tournament_players`, `tournament_matches`, `tournament_rewards` exist.
3. Deploy Worker with existing `ROOMS`, `SOCIAL`, `MATCHMAKING` bindings.
4. Keep the existing `*/5 * * * *` Worker cron.
5. Create a 4- or 8-player tournament and fill the exact player count.
6. Start the tournament and verify first-round room codes.
7. Verify only registered players can enter tournament rooms as players.
8. Open a match with `spectator=1` and verify spectator receives state but cannot move.
9. Finish a first-round game and verify the winner is propagated to the correct next-round slot.
10. Finish the final and verify champion/runner-up rewards are written exactly once.
11. Verify tournament games still update normal `games`, `rating_history` and season statistics.
12. Retain the previous Worker version for rollback.
