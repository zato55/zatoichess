# V80 Production Checklist

- [ ] Apply `db/migrations/V80.sql` to production D1.
- [ ] Configure `SHARE_EXPORT_SIGNING_SECRET` and `SHARE_EXPORT_SIGNING_KEY_ID` when signed exports are required.
- [ ] Verify key audit chain endpoint on a production fixture.
- [ ] Verify cleanup replay comparison and policy consistency history.
- [ ] Run public-share route matrix after deployment.
- [ ] Confirm owner-only authorization for all V80 endpoints.
- [ ] Confirm exports remain `private, no-store`.
