# V39 Production Checklist

1. D1 migration `V39.sql` uygula.
2. `arena_rewards` tablosu ve indekslerin oluştuğunu doğrula.
3. Worker `MATCHMAKING`, `ROOMS`, `SOCIAL` Durable Object binding'lerini doğrula.
4. `/api/system/status` ile version `39.0.0` ve migration/readiness alanlarını kontrol et.
5. Authenticated `/api/system/smoke` çalıştır.
6. Aktif Arena'ya iki veya daha fazla hesapla katıl ve Arena matchmaking üzerinden maç tamamla.
7. Arena puanlarının 2/1/0 olarak hesaplandığını doğrula.
8. Arena süresi sona erdiğinde ilk 3 ödülünün `arena_rewards` içine bir kez yazıldığını doğrula.
9. Aynı finalizasyon yolu tekrar çalıştırıldığında duplicate reward oluşmadığını kontrol et.
10. Oyuncu profilinde Arena performansı ve kazanılmış rozetlerin göründüğünü doğrula.
11. Browser push, sosyal WebSocket ve normal ELO/season sonuç akışlarının bozulmadığını doğrula.
12. Önceki Worker sürümünü rollback için sakla.

Not: Gerçek production doğrulaması yalnızca canlı Cloudflare/D1 erişimi ile yapılabilir.
