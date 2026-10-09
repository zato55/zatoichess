# ZATO Chess V49 — Production Checklist

## D1
- [ ] `db/migrations/V49.sql` production D1 üzerinde uygulanmalı.
- [ ] `tournament_shares` tablosu ve aktif-token unique index doğrulanmalı.
- [ ] `GET /api/system/status` içinde `tournament_shares` hazır görünmeli.

## Public share
- [ ] Authenticated tournament user `POST /api/tournaments/:id/share` ile link üretmeli.
- [ ] Aynı turnuva için eski aktif token yeniden üretimde revoke edilmeli.
- [ ] `DELETE /api/tournaments/:id/share` yalnızca turnuva sahibince çalışmalı.
- [ ] `/share/tournament/:token` auth olmadan açılmalı.
- [ ] OG title/description/url crawler tarafından görülebilmeli.

## Replay
- [ ] Public bracket replay linki doğru `match` parametresine gitmeli.
- [ ] Replay yalnızca paylaşılan tournament içindeki finished game için dönmeli.
- [ ] Room code / session / private profile alanları public JSON'da bulunmamalı.

## Deployment
- [ ] Cloudflare Worker deploy edilmeli.
- [ ] D1 migration production'da uygulanmalı.
- [ ] Gerçek public URL ile share + revoke + replay smoke testi yapılmalı.
- [ ] Tam npm/Vite build dependency kurulu CI ortamında çalıştırılmalı.
