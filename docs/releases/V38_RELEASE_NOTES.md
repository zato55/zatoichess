# ZATO Chess V38 — Arena Live + Matchmaking Integration

## Eklenenler
- 60 dakikalık canlı Arena oturumları: 10+0, 5+0, 3+2.
- D1 `arena_events` ve `arena_participants` tabloları.
- Arena katıl/ayrıl API'leri ve canlı leaderboard.
- Puanlama: galibiyet 2, beraberlik 1, mağlubiyet 0.
- Arena leaderboard yalnızca aynı arena'ya katılmış iki oyuncu arasındaki, arena penceresinde tamamlanan gerçek online maçları sayar.
- Arena'ya katılan kullanıcı için matchmaking kuyruğu `arena_id` ile sınırlandırılır.
- `/api/system/status` ve `/api/system/smoke` V38 arena tablolarını kontrol eder.
- V38 migration ve indeksleri.
- Sosyal panelde Arena UI, katılım durumu, canlı ilk 8 sıralama ve kişisel puan gösterimi.
- Header sürümü V38 olarak güncellendi.

## Korunan sistemler
Auth, Durable Object odaları, sosyal WebSocket, arkadaşlıklar, davet/rövanş, push bildirimleri, notification preferences, ELO/rating history, analiz, leaderboard, sezonlar ve V37 matchmaking korunmuştur.

## Doğrulama
- Tam npm build: ortamda `node_modules` bulunmadığı için çalıştırılmadı.
- Deployment/Cloudflare smoke testi: gerçek production credentials olmadığı için çalıştırılmadı.
- ZIP integrity ve statik kontroller V38 paketleme aşamasında yapılacaktır.

## Bilinen sınırlar
- Arena şu an 60 dakikalık otomatik zaman pencereleridir; Swiss/bracket turnuva formatı değildir.
- Arena puanı mevcut ELO'yu değiştirmez; gerçek ELO ve sezon güncellemesi tamamlanan online maç üzerinden devam eder.
- Arena leaderboard ilk 50 oyuncuyla sınırlıdır.

## Sonraki adım
V39: arena sonuçlarının kalıcı ödül/rozet katmanı, oyuncu/arena metrikleri ve production observability panosu.
