# V67 Production Checklist

- [ ] Apply `db/migrations/V67.sql` to D1.
- [ ] Confirm contract replay evidence writes only aggregate route/cache metadata.
- [ ] Confirm key rotation audit matches configured signing key lifecycle.
- [ ] Confirm maintenance replay hashes are deterministic across repeated runs.
- [ ] Verify owner-only access on all V67 diagnostics routes.
- [ ] Run route cache 200→304→200 replay against the deployed Worker/CDN.
- [ ] Run export signature verification with a real `SHARE_EXPORT_SIGNING_SECRET`.
- [ ] Confirm no IP/User-Agent/fingerprint data is persisted.
