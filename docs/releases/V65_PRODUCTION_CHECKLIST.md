# ZATO Chess V65 — Production Checklist

## Database
- [ ] Apply `db/migrations/V65.sql`.
- [ ] Verify replay diff table/indexes.
- [ ] Verify route contract run table/index.

## Signing
- [ ] Configure `SHARE_EXPORT_SIGNING_SECRET`.
- [ ] Configure `SHARE_EXPORT_SIGNING_KEY_ID`.
- [ ] Confirm key lifecycle reports the configured key as active.
- [ ] During rotation, deploy new key configuration before retiring the old configured key.

## Public Share
- [ ] Verify 200 responses expose `x-zato-cache: origin-miss`.
- [ ] Verify conditional 304 responses expose `x-zato-cache: conditional-hit`.
- [ ] Verify 304 does not increment view counters.

## Health / Replay
- [ ] Owner can open Share Health.
- [ ] Export verify returns deterministic reason.
- [ ] Maintenance replay remains dry-run only.
- [ ] Replay history shows previous replay and persisted diff.

## Validation limitations
The packaged source still contains inherited TypeScript parser errors from earlier releases, and dependencies are not installed in the build environment. Do not treat static regression success as production deployment validation.
