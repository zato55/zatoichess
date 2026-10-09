# V38 Production Checklist

1. V36 → V37 → V38 D1 migration sırasını uygulayın; özellikle `V38.sql` ile `matchmaking_queue.arena_id` eklenmeli.
2. `ROOMS`, `SOCIAL`, `MATCHMAKING` Durable Object binding'lerini doğrulayın.
3. Deploy sonrası authenticated `/api/system/status` içinde `version: 38.0.0`, `arena_events` ve `arena_participants` görünmeli.
4. Authenticated `/api/system/smoke` tüm kritik tablo/binding kontrollerini `ok: true` döndürmeli.
5. `/api/arena?timeControl=10%2B0` aktif 60 dakikalık arena üretmeli.
6. İki test hesabıyla arena katılımı yapılmalı; biri matchmaking'e arenaId ile girmeli.
7. Tamamlanan gerçek online maçtan sonra arena leaderboard puanı 2/1/0 mantığıyla artmalı.
8. Arena puanının ELO/season rating'den bağımsız kaldığı doğrulanmalı.
9. Arena süresi dolunca yeni zaman penceresi otomatik oluşturulmalı; eski pencere `finished` olmalı.
10. VAPID private JWK hiçbir deploy artifact'ına commit edilmemeli.
11. Production smoke: `ZATO_BASE_URL=https://... ZATO_COOKIE='zato_session=...' node scripts/smoke-test.mjs`.
12. Rollback için önceki Worker sürümü korunmalı.
