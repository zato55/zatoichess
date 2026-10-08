# V62 Production Checklist

## D1
- [ ] `db/migrations/V62.sql` production D1'de uygulanmalı.
- [ ] Migration iki kez replay edilerek idempotency doğrulanmalı.
- [ ] `tournament_share_alert_ack_audit` ve `tournament_share_maintenance_errors` indexleri doğrulanmalı.

## Share Health
- [ ] Owner Share Health açılmalı.
- [ ] Export indirilmeli; UI `SHA-256 doğrulandı` göstermeli.
- [ ] Export `schemaVersion=1.1`, `exportVersion=v62` kontrol edilmeli.
- [ ] Cache route summary ve hitRate değerleri incelenmeli.
- [ ] Alert acknowledge/unacknowledge sonrası audit kaydı görülmeli.

## Maintenance
- [ ] Scheduled maintenance çalıştırılmalı.
- [ ] Run `status=ok` veya beklenen `partial` durumu kontrol edilmeli.
- [ ] Error telemetry oluşursa stage/message doğrulanmalı.
- [ ] 90/180 günlük retention davranışı kontrol edilmeli.

## Privacy
- [ ] Exportta IP/UA/fingerprint/visitor identity bulunmadığı doğrulanmalı.
- [ ] Public share endpointleri read-only kalmalı.

## Build limitation
- [ ] Full npm/Vite/TypeScript build için bağımlılıklar kurulmalı.
- [ ] Önceki sürümlerden gelen parser hataları ayrıca temizlenmeli.
- [ ] Gerçek Cloudflare/D1/CDN/browser smoke testi production erişimiyle yapılmalı.
