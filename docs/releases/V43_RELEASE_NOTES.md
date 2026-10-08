# ZATO Chess V43 — Release Notes

## Tema
Tournament hardening: explicit draw tie-break, tournament notifications and spectator UX.

## Yeni
- Beraberlik artık belirsiz fallback değil: daha yüksek seri numarasına sahip oyuncu (daha düşük seed) ilerler.
- `tournament_matches.tie_break` ve `winner_reason` ile karar kalıcı olarak kaydedilir.
- Sonraki tur maçı hazır olduğunda iki oyuncuya `tournament_update` bildirimi gider.
- Finalde şampiyon ve ikinciye turnuva bildirimi gönderilir; mevcut notification preference, realtime ve browser-push akışı korunur.
- Seyirci ekranı salt-okunur durumunu açıkça gösterir ve “İzlemeyi bırak” aksiyonu sunar.
- Braket tamamlanan/hazır/canlı durumlarını ve tie-break kararını gösterir.
- V43 status/metrics sürüm işaretleri güncellendi.

## Migration
- `db/migrations/V43.sql`

## Validation
- `node scripts/regression-v43.mjs`
- `node --check scripts/regression-v43.mjs`
- ZIP integrity: `unzip -tq`
- Full npm/Vite build: bu ortamda bağımlılıklar kurulu olmadığı için çalıştırılmadı.

## Production
- Cloudflare production deployment bu ortamda gerçekleştirilmedi.
- Migration V43 production DB üzerinde uygulanmalıdır.
