# V71 Production Checklist

- [x] V71 regression passes
- [x] Deterministic evidence replay passes
- [x] Migration is idempotent by CREATE IF NOT EXISTS / CREATE UNIQUE INDEX IF NOT EXISTS
- [x] Verification incident lifecycle route is owner-only
- [x] Retention history route is owner-only
- [x] Replay comparison route is owner-only
- [x] Share Health UI exposes incident lifecycle and retention history
- [x] ZIP integrity verified
- [ ] Cloudflare D1 production migration execution
- [ ] Browser E2E against deployed Worker
- [ ] Real CDN/cache conditional request validation
