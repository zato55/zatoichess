# V40 Production Checklist

1. Yeni D1 migration yok; mevcut V38/V39 şemasının korunmuş olduğunu doğrula.
2. Worker `ROOMS`, `SOCIAL`, `MATCHMAKING` Durable Object binding'lerini doğrula.
3. `wrangler.toml` içinde `*/5 * * * *` Cron trigger'ın deploy edilmiş olduğunu doğrula.
4. `/api/system/status` sürümünün `40.0.0` olduğunu kontrol et.
5. Authenticated `/api/system/smoke` çalıştır.
6. Authenticated `/api/system/metrics` ile aktif Arena ve matchmaking sayaçlarını kontrol et.
7. İki veya daha fazla hesapla Arena'ya katıl ve Arena matchmaking üzerinden gerçek maç tamamla.
8. Arena puanlarının 2/1/0 olarak hesaplandığını doğrula.
9. Arena penceresi sona erdikten sonra en geç bir sonraki Cron çalışmasında ilk 3 ödülünün yazıldığını doğrula.
10. Aynı Cron/finalization tekrar çalıştırıldığında duplicate reward oluşmadığını doğrula.
11. `GET /api/arena/history` ile geçmiş Arena ve oyuncu istatistiklerini doğrula.
12. Arena viewer'da current/best streak bilgilerinin göründüğünü kontrol et.
13. Oyuncu profilindeki Arena performansı ve ödül rozetlerinin korunmuş olduğunu kontrol et.
14. Normal ELO, season, notification, WebSocket ve push akışlarının regresyon testini yap.
15. Cron, D1 ve Durable Object hatalarını Cloudflare dashboard/logları üzerinden izle.
16. Önceki Worker sürümünü rollback için sakla.

Not: Canlı Cloudflare doğrulaması credentials olmadan iddia edilmez.
