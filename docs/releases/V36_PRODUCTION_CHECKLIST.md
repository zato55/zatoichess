# ZATO Chess V36 — Production Checklist

1. Apply all D1 migrations through `db/migrations/V36.sql` in order.
2. Confirm `DB`, `ROOMS`, and `SOCIAL` bindings in Wrangler.
3. Configure `VAPID_PUBLIC_KEY`, `VAPID_PRIVATE_JWK`, and `VAPID_SUBJECT`; never commit the private JWK.
4. Deploy Worker and run `GET /api/system/status` while authenticated to verify D1 schema and bindings.
5. Create a test account and verify friend request, game invite, rematch, notification preference, browser push, and realtime social WebSocket.
6. Complete one online game and confirm `rating_history` + `season_player_stats` rows.
7. Open `/api/season`, `/api/season/leaderboard`, and `/api/seasons/history`.
8. At quarter rollover, verify previous season becomes `finalized` and top-3 rewards are created exactly once.
9. Do not run broad historical backfill directly in production without a scoped date window and monitoring.
10. After deployment, keep the first rollout reversible by retaining the previous Worker version.
