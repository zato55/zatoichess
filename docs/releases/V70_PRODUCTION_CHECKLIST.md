# V70 Production Checklist

- [ ] Apply `db/migrations/V70.sql` to production D1.
- [ ] Verify retention run telemetry after the Worker cron executes.
- [ ] Verify contract verification history is owner-only.
- [ ] Verify route-matrix export is owner-only and contains no visitor/IP/UA identity.
- [ ] Verify SHA-256 integrity on downloaded route-matrix JSON.
- [ ] Confirm evidence/summary/key-chain retention windows match policy.
- [ ] Run V70 regression and migration checks in CI.
- [ ] Perform real Cloudflare/D1/browser validation before production release.
