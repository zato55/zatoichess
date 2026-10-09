# V66 Production Checklist

- [ ] Apply `db/migrations/V66.sql` to D1.
- [ ] Run route/cache replay harness.
- [ ] Verify 200 → 304 → 200 view/cache accounting on public share routes.
- [ ] Configure and verify `SHARE_EXPORT_SIGNING_SECRET` and `SHARE_EXPORT_SIGNING_KEY_ID`.
- [ ] Verify active→new active→old retired key rotation lifecycle.
- [ ] Run migration idempotency and data-preservation checks.
- [ ] Run Cloudflare Worker deployment smoke test.
- [ ] Run browser replay/share health smoke test.
