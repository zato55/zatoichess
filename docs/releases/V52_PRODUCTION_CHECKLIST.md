# V52 Production Checklist

- [ ] Apply `db/migrations/V52.sql` to the production D1 database.
- [ ] Verify `tournament_share_rate_limits` and `tournament_share_daily` exist.
- [ ] Verify public share routes return 429 after the configured per-token rate threshold.
- [ ] Verify no IP/user-agent/fingerprint fields are persisted.
- [ ] Verify owner share stats show daily aggregate views only.
- [ ] Verify `?match=<id>&ply=<n>` restores the public replay position.
- [ ] Verify revoked/private/expired shares remain inaccessible.
- [ ] Run production smoke/status checks after deployment.
