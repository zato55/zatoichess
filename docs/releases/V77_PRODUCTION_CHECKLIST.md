# V77 Production Checklist

- [ ] Apply `db/migrations/V77.sql` to production D1.
- [ ] Verify key-chain verification returns `verified` for a known-good chain.
- [ ] Verify snapshot diff integrity hashes.
- [ ] Verify policy drift history is populated by scheduled/operator checks.
- [ ] Confirm owner-only authorization on all V77 endpoints.
- [ ] Confirm production signing key configuration separately.
- [ ] Run Cloudflare/browser route smoke tests after deployment.
