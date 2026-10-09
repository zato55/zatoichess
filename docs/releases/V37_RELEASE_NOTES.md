# ZATO Chess V37 — Release Notes

## Başlık
Production smoke-test tooling + gerçek zamanlı matchmaking temeli.

## Yeni özellikler
- `MATCHMAKING` Durable Object binding eklendi.
- D1 `matchmaking_queue` tablosu ve indeksleri eklendi.
- `/api/matchmaking/join` ile 10+0, 5+0 ve 3+2 kuyruğa katılımı.
- `/api/matchmaking/leave` ile kuyruktan çıkış.
- `/api/matchmaking/status` ile durum sorgusu.
- Eşleşme rating farkı bekleme süresine göre 100–400 puan aralığında genişliyor.
- Eşleşen oyunculara mevcut sosyal WebSocket üzerinden anlık `matchmaking:found` olayı gönderiliyor.
- Eşleşme özel Room Durable Object'e otomatik bağlanıyor.
- Room tarafında 10+0 / 5+0 / 3+2 saat kontrolü ve 3+2 increment desteği kalıcı hale getirildi.
- `/api/system/status` sürümü 37.0.0 olarak düzeltildi ve V37 şemasını/binding'lerini raporluyor.
- `/api/system/smoke` authenticated production smoke-check endpoint'i eklendi; sır/özel anahtar döndürmez.
- `scripts/smoke-test.mjs` eklendi. `ZATO_BASE_URL` veya ilk argüman ile public status, `ZATO_COOKIE` ile authenticated smoke kontrolü yapılabilir.
- Sosyal modal içine “⚡ Hızlı eşleşme” paneli eklendi.
- Kuyrukta beklerken 3 saniyelik fallback status polling var; WebSocket varsa daha hızlı eşleşme bildirimi geliyor.

## Güvenlik / dayanıklılık
- Matchmaking işlemleri global Durable Object içinde serileştirilir.
- Kuyruk kayıtları 10 dakika sonra `expired` olur.
- Aynı kullanıcının ikinci aktif kuyruk kaydı oluşturulmaz.
- Kullanıcı kendisiyle eşleşemez.
- Push/VAPID private key kaynaklara eklenmez.

## Bilinen sınırlamalar
- Gerçek production smoke testi, deployment URL'si ve geçerli kullanıcı oturumu olmadan yapılamaz.
- Tam npm/TypeScript build bu ortamda proje bağımlılıkları kurulu olmadığı için garanti edilmemiştir.
- Mevcut V36 sezon backfill davranışındaki 500 kayıt sınırı korunmuştur; V37 bunu otomatik genişletmez.

## Sonraki mantıklı adım
V38: arena/tournament oturumları, eşleşme sonrası oyun yaşam döngüsü metrikleri ve production gözlemlenebilirlik/operasyon paneli.
