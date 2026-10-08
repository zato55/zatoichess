# ZATO Chess V87 — Sürüm Notları

## Amaç
V87 yeni kullanıcı özelliği ekleyen bir sürüm değildir. V86 sonrası 1.0'a geçiş için üretim öncesi doğrulama ve devralma altyapısını netleştirir.

## Yapılanlar
- Paket sürümü 87.0.0 yapıldı.
- V87 preflight kontrolü eklendi.
- V87 regression kontrolü eklendi.
- Cloudflare/D1 yapılandırmasındaki gerçek ortam gereksinimlerini denetleyen uyarılar eklendi.
- Üretim yayın sırasını anlatan `docs/continuation/DEPLOYMENT_RUNBOOK.md` eklendi.
- Devir belgeleri V87'ye güncellendi.
- Gizli anahtarların ZIP'e konulmaması kuralı belgelendi.

## Bilinen sınırlamalar
- Gerçek Cloudflare hesabı ve D1 kimliği bu geliştirme ortamında yok.
- Gerçek üretim Worker/D1/browser/push doğrulaması kullanıcı ortamında yapılmalı.
- Tam TypeScript kontrolü bağımlılıklar kurulduktan sonra tekrar çalıştırılmalı.

## Sonraki mantıklı adım
Yeni özellik eklemek yerine gerçek ortam doğrulamasını tamamla. Tüm yayın kapıları geçerse ZATO Chess 1.0 adayı hazırlanabilir.
