# ZATO Chess V60 Release Notes

## Başlık
Share export integrity + cache route aggregation + alert acknowledgement + deterministic maintenance replay

## Eklenenler
- Share Health export artık `schemaVersion`, `exportVersion` ve SHA-256 integrity metadata içerir.
- Cache analytics için son 30 gün route bazında origin/304 toplamı ve 304 oranı gösterilir.
- Owner-only Share Health alert acknowledgement workflow eklendi; onay geri alınabilir.
- Alert acknowledgement için ayrı, privacy-safe `tournament_share_alert_ack` tablosu kullanılır.
- Scheduled share bakım işleri `runShareMaintenance()` altında deterministik hale getirildi.
- Migration/idempotency + retention/cache bakım replay testi eklendi.
- Public visitor/IP/User-Agent/fingerprint verisi tutulmaz.

## Güvenlik / Gizlilik
- Uyarı onayı yalnızca turnuva sahibinin hesabına bağlıdır.
- Export private/no-store kalır.
- Export integrity hash'i export gövdesinin SHA-256 özetidir; ziyaretçi kimliği içermez.
- Cache ölçümü hâlâ Worker-origin 200/304 gözlemidir; gerçek CDN hit/miss değildir.

## Doğrulama
- `node scripts/regression-v60.mjs` => `V60 regression OK`
- SQLite migration/idempotency + maintenance replay => OK
- `node --check scripts/regression-v60.mjs` => OK
- Full TypeScript/Vite build: V59'dan devralınan frontend JSX/parser hataları (`src/App.tsx` 47 ve 150/151) ve Worker parser hatası (`worker/index.ts(456,1397): TS1005`) nedeniyle bloke.
- Gerçek Cloudflare/D1/CDN/browser production execution yapılmadı.
