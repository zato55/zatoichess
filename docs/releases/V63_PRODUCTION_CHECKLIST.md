# V63 Production Checklist

- [x] V63 migration present and idempotent design reviewed
- [x] Export signature metadata is optional and secret-free in client payloads
- [x] Signing key id supports rotation
- [x] Alert audit filtering is owner-only and bounded
- [x] Maintenance replay is dry-run only
- [x] Replay history contains no visitor identity
- [x] Route regression script added
- [ ] Configure `SHARE_EXPORT_SIGNING_SECRET` in production
- [ ] Configure `SHARE_EXPORT_SIGNING_KEY_ID` and rotate according to deployment policy
- [ ] Run real Cloudflare/D1/browser production smoke tests
- [ ] Resolve inherited TypeScript parser/dependency issues before production build
