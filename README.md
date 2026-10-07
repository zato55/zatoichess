# ZATO Chess V11

ZATO Chess now includes the V10 authoritative online core plus the first real account layer.

## V11 additions
- D1-backed registration/login/logout/session cookies
- PBKDF2-SHA-256 password hashing (120,000 iterations)
- Authenticated WebSocket rooms
- User identity attached to online games
- Server-side Elo calculation (K=32) after rated online games
- D1 game/move persistence linked to user IDs

## D1
Apply `db/schema.sql` to a new database, or apply `db/migrations/001_auth.sql` to an existing V10 database.

## Worker secrets
No auth secret is required for the current opaque-session design. Deploy the Worker with D1 binding `DB` and Durable Object namespace `ROOMS`.

## Important
Run `npm install` and `npm run check` in a normal network-enabled environment before deployment. The build environment used during development timed out while installing npm dependencies, so a full production build could not be completed here.

## V18 — Stockfish 19 Game Review

ZATO V18 uses the `stockfish` npm package (Stockfish.js 19) and copies the lite single-threaded WASM build into `public/` during install/build. Game Review evaluates every stored position through UCI at depth 12, records the best move and engine score in memory, and classifies move loss from the engine evaluation rather than material alone.

Stockfish.js is GPL-3.0. Review the project's distribution/licensing requirements before publishing a hosted build.

## V18 — Pro Game Review
- Stockfish 19 before/after evaluation per move
- Centipawn-loss based classification
- Best-move persistence for authenticated online games


## V18 Social Core
Player search and D1-backed friend requests (pending/accepted/rejected/remove) are available through authenticated Worker APIs.


## V18 — Playable Puzzle Mode
- D1 puzzle bank and attempt tracking
- Authenticated random puzzle endpoint
- Server-side puzzle attempt persistence
- Foundation for daily puzzles, rating, streaks and tactical themes


## V18
Playable puzzle mode uses server-selected puzzles, validates solution moves in the client with chess.js, records solved attempts and elapsed time, and provides an in-game puzzle UI.


## V18
Daily puzzle, persistent puzzle rating, streaks, attempt statistics, and deterministic daily puzzle selection are included.
