# ZATO Chess V41 — Arena Anti-Abuse + Daily/Weekly Cups

## Eklenenler
- Arena yeniden-katılım anti-abuse koruması: çıkış sonrası 60 saniye cooldown, saatte en fazla 8 yeniden katılım.
- `arena_join_log` ile join/leave audit izi.
- Günlük Cup (24 saat) ve Haftalık Cup (UTC haftası) sistemi.
- Cup katıl/ayrıl, canlı leaderboard ve Cup geçmişi API/UI.
- Cup ilk 3 ödülü idempotent olarak saklanıyor.
- Cron her 5 dakikada Arena ve Cup lifecycle/finalization çalıştırıyor.
- Production smoke endpoint Cup tablolarını da kontrol ediyor.
- `scripts/regression-v41.mjs` ile bağımlılıksız otomatik yapısal regression testi.
- V41 migration, context ve production checklist güncellendi.

## Sınırlar
- Tam `tsc`/Vite build ortam bağımlılıkları kurulu değilse raporlanmaz.
- Gerçek Cloudflare production smoke testi credentials/deployment olmadan yapılmaz.
- Cup puanı Arena ile aynı 2/1/0 modelini kullanır; normal ELO'yu değiştirmez.
