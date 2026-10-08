# ZATO Chess V78 — Release Notes

## Tema
Signed verification history, policy-drift alerts ve scheduled verification replay.

## Yeni
- Owner-only V78 verification history export.
- Export SHA-256 integrity ve yapılandırılmış HMAC-SHA256 signature metadata.
- Policy drift threshold/alert history.
- Deterministic verification replay ve replay history.
- Share Health owner panelinde V78 operasyon görünümü.
- V78 migration, readiness marker ve regression contract.

## Güvenlik
- Verification export `private, no-store` olarak sunulur.
- Signing secret hiçbir response içinde açığa çıkarılmaz.
- Public-share telemetry IP, User-Agent veya fingerprint toplamaz.

## Doğrulama
- V78 regression: PASS.
- V78 SQLite migration/idempotency/data-preservation: PASS.
- Gerçek Cloudflare/D1/browser production deployment doğrulaması bu pakette yapılmamıştır.
- Önceki sürümlerden devralınan Worker parser/dependency build kısıtları devam etmektedir.
