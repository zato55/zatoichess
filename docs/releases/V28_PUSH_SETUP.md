# V28 Push Setup

1. Generate a P-256 VAPID key pair outside the repository.
2. Set Cloudflare Worker variables/secrets:
   - `VAPID_PUBLIC_KEY`: base64url-encoded uncompressed P-256 public key (65 bytes).
   - `VAPID_PRIVATE_JWK`: JSON JWK containing the P-256 private key (`kty`, `crv`, `x`, `y`, `d`).
   - `VAPID_SUBJECT`: contact URI such as `mailto:admin@example.com`.
3. Apply the added `push_subscriptions` table from `db/schema.sql` to the D1 database.
4. Deploy normally.
5. In the ZATO social modal, press **Bildirimleri aç** and grant browser permission.

Private VAPID material must never be committed to source control or the ZIP.
