# ZATO Chess V51 — Share Security + Replay Autoplay

- Share token rotation remains owner-only and every new token expires after the selected lifetime (default 30 days).
- Added owner-controlled public/private visibility. Private or expired shares return 404 from all public endpoints.
- Added owner-only PATCH settings and DELETE revoke controls.
- Public replay now includes optional autoplay.
- Public OG/share/replay routes enforce token, visibility and expiration checks.
- Added V51 migration, regression script, production checklist and continuation context.

Known limitation: full npm/Vite build and real Cloudflare deployment were not performed in this environment because project dependencies/production credentials are unavailable.
