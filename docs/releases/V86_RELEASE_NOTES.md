# ZATO Chess V86 — Yayın Notları

## Amaç
V86, 1.0 öncesi üretim sertleştirme ve Worker sözdizimi temizliği sürümüdür. Yeni kullanıcı özelliği eklemek yerine V85 üretim hazırlık katmanının güvenilir derlenebilir bir kaynak ağacı olarak kalması hedeflenmiştir.

## Yapılanlar
- Worker içindeki üç sözdizimi/ayrıştırma sorununu düzeltildi.
- V84 rotaları arasındaki bozuk kaçışlı satır sonu temizlendi.
- Bakım işinin kayıt sorgusundaki fazla parantez düzeltildi.
- Turnuva geçmişi sorgusundaki eksik kapanış düzeltildi.
- V86 regression kontrolü eklendi.
- Devir belgeleri V86 durumuna güncellendi.

## Doğrulama
- V86 regression: başarılı.
- Worker TypeScript ayrıştırma kontrolü: önceki sözdizimi hataları artık üretilmiyor.
- Tam tip kontrolü: ortamda `@cloudflare/workers-types` bulunmadığı için tamamlanamadı.
- Gerçek Cloudflare/D1/Worker/browser üretim testi henüz yapılmadı.

## Sonraki adım
V87 yalnızca gerçek üretim doğrulamasında yeni bir eksik bulunursa açılmalı. Ana hedef 1.0 adayını tamamlamaktır.
