# ZATO Chess V40 — Arena Lifecycle, History & Observability

## Yeni özellikler
- Arena kapanışları artık Cloudflare Worker Cron ile otomatik finalize ediliyor.
- Cron her 5 dakikada çalışıyor.
- V39'daki yaşam döngüsü sırası düzeltildi: bitmiş Arena ödül hesaplanmadan önce `finished` olarak işaretlenmiyor.
- `GET /api/arena/history` ile oyuncunun son Arena geçmişi geliyor.
- Arena viewer'da mevcut Arena W/D/L serisi, en iyi galibiyet serisi ve en iyi mağlubiyet serisi gösteriliyor.
- Social Arena panelinde son Arena geçmişi gösteriliyor.
- `GET /api/system/metrics` ile temel production operasyon metrikleri geliyor:
  - aktif Arena sayısı
  - bekleyen matchmaking sayısı
  - son 24 saat tamamlanan maçlar
  - son 24 saat Arena maçları
  - toplam kullanıcı sayısı
- `/api/system/smoke` ve `/api/system/status` V40 sürümüne güncellendi.
- `wrangler.toml` içine `*/5 * * * *` Cron trigger eklendi.
- `package.json` sürümü `40.0.0` oldu.

## Veri modeli
- Yeni D1 migration gerekmedi; V40 mevcut V38/V39 tablolarını kullanıyor.
- `arena_events`, `arena_participants` ve `arena_rewards` korunuyor.

## Arena lifecycle
1. Worker Cron her 5 dakikada `finalizeArenaRewards()` çalıştırır.
2. Süresi dolmuş aktif Arenalar sıralanır.
3. İlk 3 oyuncunun Arena puanı hesaplanır.
4. `arena_rewards` içine idempotent ödül kaydı yazılır.
5. Ancak bundan sonra Arena `finished` durumuna geçirilir.
6. Yeni zaman pencereleri ihtiyaç olduğunda otomatik oluşturulur.

## Bilinen sınırlamalar
- Cron'un gerçek Cloudflare ortamında çalıştığı bu paket içinde canlı credentials olmadan doğrulanamaz.
- Tam TypeScript type-check yalnızca Cloudflare Worker type bağımlılıkları kurulduğunda doğrulanabilir.
- Arena hâlâ Swiss/bracket turnuvası değil; canlı süre pencereli skor yarışmasıdır.
- Production observability endpoint'i temel operasyon metrikleri sağlar; harici log/metrics sistemi entegrasyonu sonraki aşamadır.
