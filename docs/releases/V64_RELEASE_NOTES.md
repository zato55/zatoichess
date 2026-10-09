# ZATO Chess V64 — Signed Export Verification & Maintenance Contracts

## Eklenenler
- Share Health export `v64` sözleşmesi.
- SHA-256 + opsiyonel HMAC-SHA256 export doğrulama endpoint'i.
- Export imza anahtarı yaşam döngüsü: durum listeleme, etkinleştirme, emekliye ayırma ve audit eventleri.
- Maintenance replay artık önceki replay ile deterministic diff üretir.
- Alert audit endpoint'ine `before` cursor ve `hasMore/nextBefore` pagination eklendi.
- Owner Share Health UI içinde imza anahtarı durumu ve replay diff görünümü.
- Client export doğrulamasına server-side signature verification sonucu eklendi.
- V64 route contract regression matrisi.

## Güvenlik
- HMAC secret hiçbir response veya export içine yazılmaz.
- Doğrulama owner-only endpoint üzerinden yapılır.
- Visitor/IP/User-Agent/fingerprint verisi eklenmedi.
- Key ID yalnızca metadata olarak taşınır.

## Bilinen sınırlamalar
- Gerçek Cloudflare/D1 production deploy doğrulaması yapılmadı.
- Full npm/Vite build mevcut ortamda dependency ve V62'den miras parser hataları nedeniyle doğrulanamıyor.

## Validation
- `V64 regression OK`
- `V64 sqlite migration/idempotency/data-preservation OK`
- `node --check scripts/regression-v64.mjs` OK
- Worker TypeScript check remains blocked by inherited parser errors: `worker/index.ts(138,2888): error TS1005: ';' expected.` and `worker/index.ts(473,1397): error TS1005: ')' expected.`
- `node_modules` mevcut olmadığı için full npm/Vite build çalıştırılamadı.
