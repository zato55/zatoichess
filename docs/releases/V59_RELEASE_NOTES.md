# ZATO Chess V59 Release Notes

## Başlık
Cache-aware analytics + alert history + Share Health export + scheduled retention

## Eklenenler
- `tournament_share_cache_daily`: origin 200 ve conditional 304 gözlemlerini route/gün bazında toplar.
- `tournament_share_alert_history`: Share Health uyarılarının ilk/son görülmesi ve occurrence sayısını tutar.
- Owner-only `GET /api/tournaments/:id/share/health/export` JSON export endpoint'i.
- Share Health panelinde cache origin/304 trendi ve uyarı geçmişi.
- Health JSON export butonu.
- HTML, tournament JSON, replay JSON ve OG image origin seviyesinde cache accounting.
- Scheduled cleanup: cache analytics 90 gün, alert history 180 gün.
- Cache ölçümü CDN hit/miss iddiası değildir; yalnızca Worker origin gözlemleridir.

## Güvenlik / Gizlilik
- Export yalnızca turnuva sahibine açık.
- Export `Cache-Control: private, no-store` kullanır.
- IP, User-Agent, fingerprint veya ziyaretçi kimliği tutulmaz.

## Doğrulama
- `V59 share analytics/alert history/export regression OK`
- `V59 sqlite migration/idempotency OK`
- `node --check scripts/regression-v59.mjs` OK
- Tam TypeScript/Vite build çalıştırılamıyor: V58'den devralınan `worker/index.ts(442,1397): TS1005 ')' expected` sentaks hatası V59'da satır 449'a kaymıştır.
- Gerçek Cloudflare/D1/CDN/browser production doğrulaması yapılmadı.
