# V78 Production Checklist

- [x] V78 migration dosyası mevcut.
- [x] Migration tekrar çalıştırıldığında idempotent.
- [x] Verification export integrity SHA-256.
- [x] Optional HMAC signing metadata.
- [x] Policy drift threshold endpoint.
- [x] Verification replay + replay history.
- [x] Owner-only authorization.
- [x] `private, no-store` export response.
- [x] Regression script.
- [ ] Cloudflare D1 gerçek deployment testi.
- [ ] Browser E2E testi.
- [ ] Production signing secret/key rotation smoke test.
