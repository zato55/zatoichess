# V69 Production Checklist

- [ ] `V69.sql` production D1 üzerinde uygulanmalı.
- [ ] `contract-evidence/verify` yalnızca owner oturumu ile erişilebildiği doğrulanmalı.
- [ ] `keys/chain/verify` çıktısında `valid=true` beklenmeli.
- [ ] Retention policy değerleri ürün operasyonuna göre gözden geçirilmeli.
- [ ] Evidence/summary/key-chain retention cron temizliğinin production D1 üzerinde gözlenmesi.
- [ ] CDN/cache davranışı ve public share route contractları staging ortamında tekrar oynatılmalı.
- [ ] Export signing secret/key-id production secret manager üzerinden tanımlanmalı; secret response gövdesine konulmamalı.
- [ ] Full `npm`/Vite build ve Cloudflare deploy CI ortamında doğrulanmalı.
