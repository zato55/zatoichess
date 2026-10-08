# ZATO Chess V20 Release Notes

V20, V18/V19 sosyal sistemini çevrimiçi presence ve daha hızlı davet takibiyle genişletir.

## Added
- D1 `user_presence` table + index.
- Authenticated presence heartbeat every 20 seconds.
- Friend list online state based on a 45-second heartbeat window.
- Social refresh every 5 seconds while signed in.
- Offline friends cannot be invited from the UI.
- `GET /api/invites/sent` endpoint prepared for outgoing invite state tracking.
- Project continuation context is included in `ZATO_PROJECT_CONTEXT.md` and must be carried into every future ZIP.
