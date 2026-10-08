# Next Steps — V93 sonrası

1. GitHub repository'ye V93 temiz kaynak ağacını aktar ve repo kökünü doğrula.
2. `wrangler.toml` içindeki D1 binding'i gerçek `zato-chess` ID `3bc201ad-5257-4c1d-9454-17431f48dcc2` ile eşleştir.
3. `db/migrations/` zincirini ve `db/D1_INITIAL_SETUP_V93.sql` paketini son kez kontrol et.
4. Migration'ları remote `zato-chess` D1 üzerinde doğru sırayla uygula.
5. D1 tablo, index, constraint ve migration durumunu doğrula.
6. `npm run check`, `npm run build` ve ilgili V93/release regression gate'lerini çalıştır.
7. Worker'ı gerçek Cloudflare ortamına deploy et.
8. Gerçek Worker/API/WebSocket smoke testlerini yap.
9. Gerçek browser üzerinde auth, online oyun, social, matchmaking, arena/cup, tournament, spectator, public share/replay/cache, notification ve dar ekran akışlarını doğrula.
10. Production evidence manifestini doldur.
11. `CODE_READY`, `PRODUCTION_CONFIGURED` ve `PRODUCTION_RUNTIME_VALIDATED` üç kapısını ayrı ayrı PASS yap.
12. Ancak tüm üretim kanıtları tamamlandıktan sonra 1.0 kararını ver.

Yeni özellik geliştirme, gerçek production doğrulamasında bulunan bir hata dışında bu aşamada dondurulmuştur.
