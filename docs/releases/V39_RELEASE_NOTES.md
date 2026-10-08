# ZATO Chess V39 — Arena Rewards & Player Metrics

## Yeni özellikler
- Arena kapanışında ilk 3 oyuncu için idempotent ödül kaydı.
- Ödüller: `arena_champion`, `arena_runner_up`, `arena_podium`.
- Arena leaderboard artık kazanma oranı, kayıp sayısı ve ödül rozetini döndürüyor.
- Arena viewer kartında mevcut ödül/rozet gösteriliyor.
- Oyuncu profiline toplam Arena sayısı, Arena maçları, puan, W/D/L ve kazanma oranı eklendi.
- Oyuncunun son 12 Arena ödülü profilde gösteriliyor.
- Smoke test Arena reward tablosunu da kontrol ediyor.
- `/api/system/status` sürümü V39 olarak güncellendi.

## Veri modeli
- `db/migrations/V39.sql`
- `arena_rewards` tablosu ve iki indeks.
- `UNIQUE(arena_id,user_id)` ile aynı Arena için ödül tekrarını engelliyor.

## Ödül mantığı
- Arena penceresi kapandığında ilk 3 sıralama hesaplanır.
- 1. = 🏆 Şampiyon
- 2. = 🥈 İkincilik
- 3. = 🥉 Podyum
- Finalizasyon tekrar çalışsa bile `INSERT OR IGNORE` ikinci kayıt oluşturmaz.

## Doğrulama
- SQL migration SQLite ile test edilmelidir.
- ZIP integrity ve SHA-256 paketleme sırasında kontrol edilmelidir.
- Tam npm/TypeScript build yalnızca bağımlılıklar gerçekten kurulabildiğinde başarılı olarak raporlanacaktır.
- Gerçek Cloudflare production testi credentials olmadan iddia edilmez.
