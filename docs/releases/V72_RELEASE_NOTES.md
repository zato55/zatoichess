# ZATO Chess V72 — Release Notes

## Tema
Verification incident audit, replay comparison integrity, retention error telemetry ve public-share contract matrix regression.

## Yeni
- `tournament_share_verification_incident_audit` ile incident durum değişiklikleri audit ediliyor.
- Replay karşılaştırmaları `tournament_share_replay_comparisons` içinde kalıcılaştırılıyor.
- Comparison export SHA-256 integrity bilgisi taşıyor.
- Retention aşama hataları `tournament_share_retention_errors` içinde tutuluyor.
- Owner-only incident audit, comparison history/export ve retention error endpointleri eklendi.
- Public-share route contract matrix için deterministik regression fixture eklendi.
- Readiness required-table listesi V72 tablolarını kapsıyor.

## Güvenlik
- Incident audit ve comparison verileri yalnızca turnuva sahibine açık.
- Comparison export `private, no-store`.
- Ziyaretçi IP/UA/fingerprint tutulmuyor.

## Doğrulama
- `V72 regression OK`
- `V72 public-share contract matrix OK`
- `V72 sqlite migration/idempotency/data-preservation OK`
- ZIP integrity OK
- Worker TypeScript kontrolü yalnızca V62/V71'den devralınan iki parser hatasıyla sınırlı:
  - `worker/index.ts(161,2888): TS1005`
  - `worker/index.ts(516,1397): TS1005`
- Gerçek Cloudflare/D1/browser production testi bu ortamda yapılmadı.
