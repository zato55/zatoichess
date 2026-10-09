# ZATO Chess V61 Release Notes

## Başlık
Export verification + alert lifecycle + maintenance diagnostics

## Eklenenler
- Share Health export sürümü `v61` olarak işaretlendi; schemaVersion ve SHA-256 integrity metadata korunuyor.
- Owner UI export indirme sonrasında export sürümü/şema ve bütünlük hash'ini gösteriyor.
- Alert acknowledgement artık occurrence-aware: onaylanan occurrence sayısı saklanıyor; yeni alert occurrence oluştuğunda eski onay otomatik olarak yetersiz kalıyor.
- Owner-only maintenance diagnostics endpoint son scheduled bakım çalışmalarını ve silinen/aggregate edilen kayıt sayılarını gösteriyor.
- Scheduled share maintenance sonuçları `tournament_share_maintenance_runs` tablosunda privacy-safe olarak tutuluyor ve 90 günde temizleniyor.
- Cache route analytics UI ve maintenance diagnostics birlikte izlenebilir hale getirildi.

## Migration
- `db/migrations/V61.sql`
- `tournament_share_alert_ack` occurrence-aware yapıya geçirildi.
- `tournament_share_maintenance_runs` eklendi.

## Güvenlik / Gizlilik
- Visitor IP, User-Agent, fingerprint veya kimlik bilgisi eklenmedi.
- Maintenance diagnostics yalnızca turnuva sahibine açık.
- Export private/no-store olmaya devam ediyor.
- SHA-256 yalnızca export bütünlüğü içindir; kimlik/ziyaretçi takibi değildir.

## Bilinen sınırlamalar
- Cache origin/304 ölçümü Worker-origin gözlemidir; gerçek CDN hit/miss metriği değildir.
- Full TypeScript/Vite build, V59'dan devralınan parser/dependency sorunları nedeniyle doğrulanamadı.
- Gerçek Cloudflare/D1/CDN/browser production execution yapılmadı.
