# V73 Production Checklist

- [ ] Apply `db/migrations/V73.sql` in D1.
- [ ] Verify owner authorization for all V73 endpoints.
- [ ] Verify route-matrix snapshot hashes against exported payloads.
- [ ] Verify incident audit export hashes.
- [ ] Verify retention-error action lifecycle: open → acknowledged → resolved → open.
- [ ] Run deterministic replay bundle against a staging tournament share.
- [ ] Confirm private/no-store headers on exports.
- [ ] Confirm retention policies are scheduled and monitored.
- [ ] Run Cloudflare Worker/D1/browser smoke tests after deployment.
