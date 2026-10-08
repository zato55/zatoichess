# V52 Release Notes

## Public Share Rate Limiting + Privacy-safe Analytics + Replay State

- Public tournament share routes are rate-limited per share token hash: 60 requests/minute.
- No IP address, user-agent, fingerprint, or visitor identity is stored.
- Share analytics now keep daily aggregate view counts in `tournament_share_daily`.
- Owner share stats return the latest 14 daily aggregate buckets.
- Old rate-limit buckets are cleaned by the Worker scheduled task.
- Public replay deep-links now support `?match=<matchId>&ply=<n>`.
- Public replay page restores the requested move position and preserves it in the canonical URL.
- Public replay API returns `selectedPly` and remains read-only.
- Existing V49/V50/V51 visibility, expiration, revoke and owner authorization rules remain enforced.
- `db/migrations/V52.sql` adds rate-limit and daily-aggregate tables/indexes.
- Package version: `52.0.0`.

## Validation

- Dependency-free regression script: `node scripts/regression-v52.mjs`
- Full npm/Vite build remains unavailable in the minimal environment because project dependencies are not installed.
- Production Cloudflare deployment was not performed.
