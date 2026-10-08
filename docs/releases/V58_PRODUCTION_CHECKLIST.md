# ZATO Chess V58 Production Checklist

## Database
- [ ] Apply `db/migrations/V58.sql` to production D1.
- [ ] Verify both V58 audit indexes exist.
- [ ] Confirm V57 scheduled retention/aggregation job remains enabled.

## Public Share Health
- [ ] Owner-only `/api/tournaments/:id/share/health` returns alert state and 30-day trend.
- [ ] `rate-limit` alert appears only when blocked requests exist.
- [ ] `expiration-soon` appears at <=7 days remaining.
- [ ] Private/revoked states remain owner-visible but public routes remain inaccessible.

## Cache
- [ ] Verify `x-zato-cache: origin-miss` on Worker-generated 200 responses.
- [ ] Verify `x-zato-cache: conditional-hit` on matching ETag 304 responses.
- [ ] Confirm 304 responses do not increment public view counters.
- [ ] Validate behavior through the actual CDN/browser stack after deployment.

## Scheduled Tasks
- [ ] Verify daily audit aggregation runs.
- [ ] Verify raw audit retention remains 90 days.
- [ ] Verify rate-limit and abuse-window cleanup remains active.

## Release validation
- [x] Regression script passes locally.
- [x] SQLite migration/idempotency passes locally.
- [x] ZIP integrity checked.
- [ ] Full npm/Vite production build after dependencies are installed.
- [ ] Cloudflare deployment smoke test.
