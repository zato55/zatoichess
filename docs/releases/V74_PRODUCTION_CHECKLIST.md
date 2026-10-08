# V74 Production Checklist

- [ ] Configure `SHARE_EXPORT_SIGNING_SECRET` in production.
- [ ] Configure `SHARE_EXPORT_SIGNING_KEY_ID`.
- [ ] Verify replay-bundle signature/verification responses.
- [ ] Verify contract matrix diff history.
- [ ] Verify retention action audit chain.
- [ ] Run cleanup replay before enabling any future destructive cleanup.
- [ ] Validate D1 migration V74 in staging.
- [ ] Run browser/Cloudflare production smoke tests.
