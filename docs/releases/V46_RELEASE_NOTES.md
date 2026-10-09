# ZATO Chess V46 — Release Notes

## Added
- Tournament analytics are now exposed on player profiles.
- Profile tournament summary: tournaments, games, wins, losses, tie-breaks, tie-break wins, championships and runner-up finishes.
- Recent tournament history is visible directly from the player profile.
- Tournament history rows now include participant count, player wins/losses and tie-break count.
- Tournament detail adds compact live/final analytics for completed matches and tie-breaks.
- V46 query indexes for tournament player/winner/player-pair lookups.
- `scripts/regression-v46.mjs`.

## Preserved
- V45 rating-neutral replay tie-break behavior.
- V44 replay rooms and tournament history.
- V43 notifications and explicit tie-break rules.
- V42 bracket and spectator mode.

## Validation
- V46 structural regression.
- V42 → V43 → V44 → V45 → V46 migration-chain validation.
- Tournament analytics/profile query fixture validation.
- ZIP integrity validation.

## Known limitations
- Full production deployment is not performed.
- Full npm/Vite build is not performed when dependencies are unavailable.
- Tournament analytics are derived from bracket records rather than a separate denormalized stats table; this keeps the model idempotent and avoids another write path.
