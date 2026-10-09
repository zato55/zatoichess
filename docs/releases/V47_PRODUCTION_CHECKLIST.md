# V47 Production Checklist

1. Apply `db/migrations/V47.sql` after V46.
2. Confirm `tournament_players.rating_at_entry` exists and is backfilled.
3. Confirm V47 readiness reports migration `tournament-round-analytics-and-entry-rating`.
4. Create a new 4/8-player tournament and verify entry ratings are snapshotted.
5. Complete at least one round and verify round analytics / opponent rating.
6. Run a replay tie-break and verify tie-break history plus replay review shortcut.
7. Verify replay games remain rating-neutral as established in V45.
8. Verify old tournaments still load without analytics errors.
9. Verify tournament profile analytics and history.
10. Keep rollback to V46 deployment/migration package.
