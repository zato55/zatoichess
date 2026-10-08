# V37 Production Checklist

1. `db/migrations/001_auth.sql` → `V36.sql` ve `V37.sql` sırasını D1'e uygulayın.
2. Wrangler'da `ROOMS`, `SOCIAL`, `MATCHMAKING` Durable Object binding'lerini doğrulayın.
3. `VAPID_PUBLIC_KEY`, `VAPID_PRIVATE_JWK`, `VAPID_SUBJECT` secret/vars yapılandırmasını kontrol edin; private JWK'yi repoya koymayın.
4. Worker deploy sonrası `GET /api/system/status` çağrısında `version: 37.0.0` ve `matchmaking: true` görülmeli.
5. Yetkili bir oturum ile `GET /api/system/smoke` çalıştırın; tüm kritik kontroller `ok: true` olmalı.
6. Local/CI smoke: `ZATO_BASE_URL=https://... ZATO_COOKIE='zato_session=...' node scripts/smoke-test.mjs`.
7. İki test hesabıyla aynı süre kontrolünde hızlı eşleşmeyi deneyin; iki istemci aynı 6 karakterli oda koduna yönlenmeli.
8. 3+2 testinde ilk hamleden sonra increment'in her iki oyuncunun saatine doğru eklendiğini doğrulayın.
9. Eşleşme sonrası tamamlanan maçta `games.time_control`, `rating_history` ve `season_player_stats` kayıtlarını kontrol edin.
10. Kuyrukta bekleyen kullanıcı için iptal, 10 dakika expiry ve tekrar kuyruğa katılımı test edin.
11. Production'da önceki Worker sürümünü rollback için tutun.
12. Smoke endpoint'i secrets, VAPID private JWK veya kullanıcı şifresi döndürmemelidir.
