# ZATO Chess V47 — Tournament Analytics & Replay History

## Yeni özellikler
- Turnuva oyuncularında `rating_at_entry` snapshot'ı.
- Tur bazlı analytics: tamamlanan/canlı maç ve tie-break sayıları.
- Turnuva ortalama giriş rating'i ve rakip gücü.
- Standings'te oyuncu başına ortalama rakip rating'i ve tie-break performansı.
- Tie-break geçmişi API çıktısı; normal oyun ve replay game ID'leri korunuyor.
- Bracket maçlarında giriş rating'leri.
- Tamamlanmış normal maç ve replay tie-break için doğrudan "Maçı incele / Replay incele" kısayolları.
- Oyuncu profilinde turnuva bazında ortalama rakip rating'i ve tie-break geçmişi.
- Yeni indeksler: oyuncu rating snapshot, tur/status ve replay/game lookup.

## Veri davranışı
- Analytics tarihsel olarak stabil kalır; rakip gücü turnuvaya girişteki rating snapshot'ından hesaplanır.
- V45'teki rating-neutral replay tie-break davranışı korunur.
- Eski V42-V46 kayıtları için migration, mevcut kullanıcı rating'inden tek seferlik snapshot backfill eder.

## Validation
- `node scripts/regression-v47.mjs`
- `node --check scripts/regression-v47.mjs`
- SQLite V42→V43→V44→V45→V46→V47 migration/idempotency smoke test
- Full npm/Vite build: dependency environment unavailable; production build not claimed.
