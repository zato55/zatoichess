# ZATO Chess V45 — Release Notes

## Added
- Tournament standings in tournament detail.
- Explicit player rank/seed/played/wins/losses/points summary.
- Tournament replay tie-break games are now rating-neutral.
- Replay games remain persisted for history/review and tournament progression.
- Supporting indexes for tournament winner/player lookups.
- `scripts/regression-v45.mjs`.

## Validation
- V45 structural regression.
- V42 → V43 → V44 → V45 migration-chain validation.
- ZIP integrity validation.

## Known limitations
- Full production deployment is not performed.
- Full npm/Vite build is not performed when dependencies are unavailable.
- Standings are bracket-derived and intentionally award 3 points per completed tournament win; they are not a separate league rating.
