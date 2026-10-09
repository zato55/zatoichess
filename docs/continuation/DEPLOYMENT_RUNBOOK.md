# ZATO Chess — Üretim Yayın Rehberi

Bu belge gerçek Cloudflare üretim ortamına geçişte izlenecek kısa sırayı tutar. Gizli anahtarlar veya gerçek kimlik bilgileri bu depoya/ZIP'e yazılmaz.

## 1. Ortamı hazırla
- Node.js ve npm kurulu olmalı.
- Bağımlılıklar `npm install` ile kurulmalı.
- `npm run check` ile frontend ve Worker tip kontrolü çalıştırılmalı.
- `npm run preflight:v87` çalıştırılmalı.

## 2. Cloudflare bağlantısını doğrula
- `wrangler.toml` içindeki `database_id` gerçek D1 kimliğiyle değiştirilir.
- Worker adı ve Durable Object sınıfları Cloudflare hesabındaki kaynaklarla eşleşir.
- Gerekli gizli anahtarlar Cloudflare Secret olarak tanımlanır; ZIP'e yazılmaz.

## 3. Veri tabanı
- Migration'lar gerçek D1 üzerinde sırayla uygulanır.
- Uygulama öncesi yedek/geri dönüş planı doğrulanır.
- Hazır olma ve tablo kontrolleri çalıştırılır.

## 4. Yayın öncesi
- `npm run build`
- `npm run regression:v87`
- `npm run preflight:v87`
- Gerçek Worker smoke testleri
- Giriş, arkadaşlık, maç, turnuva, paylaşım ve bildirim akışları
- Mobil görünüm ve tarayıcı testi

## 5. Yayın sonrası
- Sistem durum ekranı kontrol edilir.
- D1 hata oranları ve Worker günlükleri izlenir.
- Turnuva zamanlayıcısının çalıştığı doğrulanır.
- Paylaşım/cache/temizlik sağlık kontrolleri gözden geçirilir.

## Önemli
Gerçek Cloudflare erişimi olmayan bir geliştirme ortamında bu adımların yalnızca yerel/preflight kısmı doğrulanabilir. Bu durum üretim onayı olarak yorumlanmamalıdır.
