# V41 Production Checklist

1. `db/migrations/V41.sql` D1'e uygula.
2. `/api/system/status` ile V41 tablolarının tamamını doğrula.
3. Worker Cron `*/5 * * * *` aktif olmalı.
4. Arena join/leave cooldown ve saatlik yeniden-katılım limitini test et.
5. Günlük ve haftalık Cup'a katıl/ayrıl akışını test et.
6. Cup bitiminde ilk 3 ödülün tek kez yazıldığını doğrula.
7. `/api/cup`, `/api/cup/history`, `/api/system/metrics` smoke testlerini çalıştır.
8. `npm run regression` ile V41 yapısal regression testini çalıştır.
9. Production deploy öncesi gerçek kullanıcılarla kısa Arena + Cup smoke maçı yap.
10. Önceki Worker sürümünü rollback için tut.
