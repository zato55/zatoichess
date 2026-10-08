# V28 — Native Browser Push Notifications

- Added D1 `push_subscriptions` storage.
- Added `/api/push/config`, `/api/push/subscribe` GET/POST/DELETE.
- Added Service Worker push + notification click handling.
- Added configurable VAPID public key/private JWK/subject Worker environment variables.
- Notification creation now triggers browser push delivery when VAPID is configured.
- WebSocket social notifications and database persistence remain unchanged as fallback.
- Expired push endpoints (404/410) are removed automatically.
- No private VAPID material is included in the repository/ZIP.
