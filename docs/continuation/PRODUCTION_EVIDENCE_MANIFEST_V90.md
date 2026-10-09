# ZATO Chess — 1.0 Üretim Kanıtı Manifestosu

Bu belge V92 devir paketinde tutulan güncel üretim doğrulama sözleşmesidir. Kod tarafındaki başarı, üretim doğrulamasının yerine geçmez.

## Zorunlu kapılar
- `CODE_READY`: kaynak, migration, regression ve paket bütünlüğü doğrulanmalı.
- `PRODUCTION_CONFIGURED`: Cloudflare Worker, D1, alan adı ve gerekli gizli değişkenler gerçek ortamda tanımlanmalı.
- `PRODUCTION_RUNTIME_VALIDATED`: gerçek ortamda kritik kullanıcı ve bakım akışları smoke test edilmelidir.
- `1.0_DECISION`: yalnızca üç kapı da `PASS` olduğunda `APPROVED` olabilir.

## Minimum gerçek ortam testleri
1. Worker sağlık/okuma rotaları.
2. D1 migration ve tablo hazır olma kontrolü.
3. Kullanıcı oturumu.
4. Online satranç odası ve hamle akışı.
5. Arkadaşlık/davet/bildirim.
6. Eşleştirme ve tamamlanan maç.
7. Arena/Cup.
8. 4/8 kişilik turnuva ve seyirci erişimi.
9. Genel turnuva paylaşımı, replay ve ETag/304.
10. Share Health, saklama replay ve bakım akışları.
11. Tarayıcı push bildirimleri.
12. Gerçek tarayıcıda masaüstü + dar ekran kontrolü.

Gerçek Cloudflare erişimi olmadan `PRODUCTION_CONFIGURED` ve `PRODUCTION_RUNTIME_VALIDATED` PASS kabul edilmez.
