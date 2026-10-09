# V64 Production Checklist

- [ ] `V64.sql` D1 production'a uygulanmalı.
- [ ] `SHARE_EXPORT_SIGNING_SECRET` secret olarak tanımlanmalı.
- [ ] `SHARE_EXPORT_SIGNING_KEY_ID` deploy konfigürasyonunda benzersiz tutulmalı.
- [ ] İlk Share Health export sonrası `/export/verify` sözleşmesi smoke test edilmeli.
- [ ] Key lifecycle ekranında aktif key doğrulanmalı.
- [ ] Key rotation sırasında yeni key deploy edilip eskisi emekliye ayrılmalı.
- [ ] Maintenance replay diff gözden geçirilmeli; replay dry-run'dır, retention uygulamaz.
- [ ] Alert audit pagination ile eski kayıtların okunabildiği doğrulanmalı.
- [ ] CDN/Worker cache davranışı gerçek ortamda ayrıca doğrulanmalı.
