# V60 Production Checklist

- [x] V59 kaynak alınarak değişiklikler uygulandı
- [x] V60 migration eklendi ve idempotent tasarlandı
- [x] Export version + SHA-256 integrity metadata eklendi
- [x] Cache route aggregation UX eklendi
- [x] Alert acknowledgement / undo workflow eklendi
- [x] Scheduled maintenance helper çıkarıldı
- [x] Deterministic maintenance replay testi eklendi
- [x] Regression geçti
- [x] SQLite migration/idempotency geçti
- [x] ZIP integrity kontrolü yapılacak
- [ ] Full npm/Vite build — devralınan App/Worker parser hataları nedeniyle bloke
- [ ] Cloudflare deployment doğrulaması
- [ ] Gerçek CDN cache hit/miss doğrulaması
- [ ] Gerçek browser ETag/304 doğrulaması
