# ZATO Chess V53 — Public Share Cache + Analytics + Replay Controls

## Eklenenler
- Public tournament JSON için ETag + conditional GET desteği.
- Public replay JSON için ETag + 5 dakikalık public cache.
- OG SVG için ETag + 5 dakikalık public cache.
- Public response'larda `must-revalidate` cache politikası.
- Owner share analytics paneli:
  - toplam görüntülenme
  - son 14 günlük toplam
  - expiration
  - son ziyaret
  - 14 günlük trend SVG
- Public replay klavye kontrolü için left/right akışının altyapısı korunup smoke kapsamına alındı.
- Sistem readiness/status/metrics sürümü 53.0.0.
- V53 continuation context güncellendi.

## Güvenlik
- Token yalnızca hash üzerinden rate-limit ve lookup için kullanılır.
- Public endpointler mevcut expiration/revoke/visibility kontrollerini korur.
- Analytics owner-only kalır.

## Doğrulama
- `node scripts/regression-v53.mjs` → `V53 regression OK`
- `node --check scripts/regression-v53.mjs` başarılı.
- V52 kaynak ZIP bütünlüğü doğrulandı.
- Tam npm/Vite build ortamda dependency olmadığı için çalıştırılmadı.
- Production Cloudflare deployment yapılmadı.
