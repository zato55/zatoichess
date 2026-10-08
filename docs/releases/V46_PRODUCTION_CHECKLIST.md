# V46 Production Checklist

1. Apply `db/migrations/V46.sql` after V42/V43/V44/V45 migrations.
2. Confirm tournament indexes exist.
3. Deploy Worker/frontend with existing ROOMS, SOCIAL and MATCHMAKING bindings.
4. Keep existing `*/5 * * * *` cron.
5. Open a player profile and verify Tournament performance renders without errors.
6. Open a finished tournament and verify participants, wins/losses and tie-break analytics.
7. Verify replay tie-break games remain excluded from Elo/rating history.
8. Verify tournament history continues to show older V42–V45 tournaments.
9. Verify tournament notifications, bracket progression and spectator mode.
10. Verify `/api/system/status`, `/api/system/smoke` and `/api/system/metrics` report V46.
11. Keep the previous V45 deployment/version available for rollback.
