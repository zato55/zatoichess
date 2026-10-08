# ZATO Chess V92 — 1.0 Geçiş Sözleşmesi

## Amaç
V92 yeni kullanıcı özelliği eklemez. V91 yayın adayını gerçek üretim doğrulamasına hazırlayan son teknik sözleşmedir.

## Tamamlananlar
- 1.0 kararının kod hazırlığı ve üretim doğrulamasını ayrı tutan yayın kapısı korunmuştur.
- Üretim kanıtlarının tek bir manifest üzerinden toplanması tanımlanmıştır.
- Kanıt eksikse 1.0 kararının otomatik olarak engellenmesi korunmuştur.
- Devir belgeleri ve üretim çalışma akışı güncellenmiştir.
- V92 regression testi eklenmiştir.

## Bilinçli olarak yapılmayanlar
- Yeni oyun, sosyal, turnuva veya paylaşım özelliği eklenmedi.
- Gerçek Cloudflare/D1 üretim doğrulaması sahte veriyle PASS yapılmadı.
- Gizli anahtarlar projeye eklenmedi.

## 1.0 için kalan gerçek dünya kanıtları
1. Worker üretim dağıtımı.
2. D1 migration uygulaması ve tablo kontrolü.
3. Gerçek tarayıcıda oturum/oyun/turnuva akışları.
4. Gerçek public share + replay + cache davranışı.
5. Push bildirimi üretim kontrolü.
6. Hata/sağlık uç noktalarının üretim kontrolü.
7. Kanıt manifestinin kaydedilmesi.

V92 bu maddeleri gerçekleştirilmiş kabul etmez; yalnızca uygulanacak tek akışı sabitler.
