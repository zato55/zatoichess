# ZATO Chess — V89 Yayın Adayı

V89 yeni kullanıcı özelliği ekleyen bir sürüm değildir. V88'deki yayın kapısını temel alır ve 1.0 adayının değişmez, tekrar doğrulanabilir bir kaynak durumu olarak paketlenmesini sağlar.

## Karar durumu
- CODE_READY: PASS
- PRODUCTION_CONFIGURED: PENDING
- PRODUCTION_RUNTIME_VALIDATED: PENDING
- 1.0_DECISION: BLOCKED_UNTIL_PRODUCTION_EVIDENCE

## Değişmezlik ilkesi
Gerçek üretim doğrulaması başlamadan V89 kaynak ağacına özellik eklenmemelidir. Üretim doğrulamasında bulunan hata varsa yeni bir sürüm adayı hazırlanmalı ve yeniden doğrulanmalıdır.

## Kaynak doğrulama
`npm run release-candidate:v89` V89 regression, V88 regression ve V88 yayın kapısını sırayla çalıştırır; ardından kritik kaynak dosyalarının SHA-256 değerlerini üretir.

## Üretimde doğrulanması gerekenler
- Cloudflare Worker yayını
- D1 migration ve veri bütünlüğü
- gerçek tarayıcıda giriş/maç/sosyal/turnuva akışları
- WebSocket ve yedek yoklama akışı
- tarayıcı bildirimleri
- public tournament share/replay/cache akışları
- bakım ve saklama replay akışları
- gerçek gizli anahtar yapılandırması

Bu çalışma ortamında bunlar doğrulanmış kabul edilmez.
