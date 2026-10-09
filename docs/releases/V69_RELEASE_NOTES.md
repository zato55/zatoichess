# ZATO Chess V69 — Release Notes

## Odak
Public Tournament Share Health sisteminde V68 ile eklenen sözleşme kanıtı özetleri ve key-audit zinciri artık yeniden hesaplanıp kriptografik olarak doğrulanabilir. Kanıtlar için açık bir retention politikası da tanımlandı.

## Eklenenler
- `GET /api/tournaments/:id/share/health/contract-evidence/verify` ile saklanan özetin ham route kanıtlarından deterministik yeniden hesaplanması.
- `GET /api/tournaments/:id/share/health/keys/chain/verify` ile SHA-256 zincir bütünlüğü doğrulaması.
- `GET /api/tournaments/:id/share/health/retention` ile retention politikasının owner-only okunması.
- `db/migrations/V69.sql` ile public-share evidence retention policy.
- V69 regression sözleşmeleri.

## Güvenlik
- Tüm yeni health endpointleri turnuva sahibi ile sınırlandırıldı.
- Ziyaretçi IP/User-Agent/fingerprint verisi eklenmedi.
- Key-chain doğrulaması sır/anahtar materyalini döndürmez; yalnızca bütünlük sonucu ve hash başını raporlar.

## Doğrulama
- `node scripts/regression-v69.mjs` → PASS
- SQLite V68→V69 migration/idempotency testi → PASS
- TypeScript check → V62’den devralınan parser hataları devam ediyor (`worker/index.ts` satır 155 ve 500 civarı); V69 değişiklikleri ayrı regression ile doğrulandı.
- Full Vite production build → bağımlılık/ortam nedeniyle garanti edilemedi.
- Gerçek Cloudflare/D1 production smoke → erişim/credential olmadığı için yapılmadı.
