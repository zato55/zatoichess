# ZATO Chess V68 — Contract Evidence Summary & Key Audit Chain

## Yeni
- Public share contract replay evidence için kalıcı özet kayıtları.
- Route bazlı toplam/passed/failed ve 200/304 dağılımı.
- Key rotation audit kayıtları için hash-chain görünümü.
- Owner-only contract evidence summary endpoint.
- Owner-only key audit chain endpoint.
- Readiness/migration marker 68.0.0.

## Doğrulama
- V68 static regression.
- SQLite migration idempotency/data preservation.
- ZIP integrity ve SHA-256.

## Bilinen sınırlamalar
- Full Worker/Vite production build, V67'den miras parser/dependency sınırlamaları nedeniyle burada doğrulanamaz.
- Gerçek Cloudflare/D1 production deploy testi yapılmamıştır.
