# ZATO Chess V62 — Release Notes

## Odak
V61 Share Health/export katmanının operasyonel doğrulamasını derinleştirir.

## Yeni özellikler
- Client-side canonical SHA-256 verification: indirilen Share Health exportunun `integrity.sha256` değeri tarayıcıda yeniden hesaplanır ve karşılaştırılır.
- Export `schemaVersion=1.1`, `exportVersion=v62`; cache route summary artık toplam ve conditional-hit oranını (`hitRate`) içerir.
- Alert acknowledgement audit trail: acknowledge/unacknowledge işlemleri `tournament_share_alert_ack_audit` ile occurrence sayısıyla birlikte tutulur. IP/UA/fingerprint/visitor identity tutulmaz.
- Scheduled maintenance error telemetry: her bakım adımı izole hata yakalama ile çalışır; `ok/partial`, hata sayısı ve stage/message bilgileri owner-only diagnostics üzerinden görülebilir.
- Cache route comparison: HTML, tournament JSON, replay JSON ve OG image için 30 günlük origin/304 toplamları ve conditional-hit oranı.
- Maintenance metadata/error tabloları kullanıldığı için mevcut V61 maintenance kayıtları korunur.

## API
- `GET /api/tournaments/:id/share/health` cache summary'lerinde `total` ve `hitRate` alanları bulunur.
- `GET /api/tournaments/:id/share/health/maintenance` V62 run status/error count ve son maintenance errors bilgisini döndürür.
- `POST /api/tournaments/:id/share/health/ack` acknowledgement audit kaydı üretir.
- `GET /api/tournaments/:id/share/health/export` V62 export + cache summary + acknowledgement audit + maintenance run summary döndürür.

## Validation
- `node scripts/regression-v62.mjs` => `V62 regression OK`.
- `node --check scripts/regression-v62.mjs` => OK.
- SQLite migration/idempotency/data-preservation replay => OK.
- Full TypeScript/Vite build mevcut workspace'te `node_modules` bulunmadığı için çalıştırılamadı; ayrıca önceki sürümlerden devralınan parser sorunu devam etmektedir.
- Gerçek Cloudflare Worker/D1/CDN/browser production execution doğrulanmadı.

## Security/privacy
- Public share token hash yaklaşımı korunur.
- Export owner-only ve `private, no-store` kalır.
- Analytics ziyaretçi kimliği, IP, User-Agent veya fingerprint toplamaz.
