# V45 Production Checklist

1. Apply `db/migrations/V45.sql` after V44.
2. Confirm tournament indexes exist.
3. Deploy Worker/frontend with existing bindings.
4. Create 4/8-player tournament and inspect standings.
5. Run a replay tie-break and confirm its game is persisted.
6. Confirm replay tie-break does not create `rating_history` rows or alter Elo/season stats.
7. Confirm normal tournament games still affect Elo/season stats.
8. Confirm final champion/runner-up rewards remain idempotent.
9. Run production smoke checks and keep V44 rollback available.
