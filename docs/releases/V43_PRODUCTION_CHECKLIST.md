# ZATO Chess V43 — Production Checklist

1. `db/migrations/V43.sql` migration'ını mevcut D1 veritabanına uygula.
2. `tournament_matches` için `tie_break`, `winner_reason` kolonlarını ve `notification_preferences.tournament_update` kolonunu doğrula.
3. Worker/Durable Object bindinglerini mevcut V42 dağıtımıyla koruyarak deploy et.
4. Cron `*/5 * * * *` korunmalı.
5. 4 veya 8 oyunculu turnuva oluştur; tam oyuncu sayısıyla başlat.
6. Bir ilk tur maçını beraberlikle bitir ve daha düşük seed'li oyuncunun ilerlediğini doğrula.
7. Brakette tie-break nedeninin göründüğünü doğrula.
8. Sonraki tur oyuncularının turnuva bildirimlerini aldığını doğrula.
9. Seyirci bağlantısının salt-okunur olduğunu, oyuncu slotu tüketmediğini ve “İzlemeyi bırak” ile kapandığını doğrula.
10. Final sonrası champion/runner-up ödüllerinin ve bildirimlerinin idempotent kaldığını doğrula.
11. Normal oyunların ELO, sezon, rating history ve game result bildirim akışlarının değişmediğini doğrula.
12. Rollback için V42 artifact'ını sakla.
