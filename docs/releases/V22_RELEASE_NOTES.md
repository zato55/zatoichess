# ZATO Chess V22 Release Notes

## Gerçek Zamanlı Sosyal Kanal

- `SocialDurableObject` eklendi.
- Her kullanıcı için deterministik Durable Object kimliği ile sosyal WebSocket kanalı oluşturuldu.
- Authenticated `GET /ws/social` endpoint’i eklendi.
- Arkadaşlık ve oyun daveti bildirimleri D1’e yazıldıktan sonra bağlı istemciye `social:notification` olayı olarak push ediliyor.
- Frontend bağlantı kopmalarında otomatik yeniden bağlanıyor.
- 30 saniyelik polling fallback korunarak bağlantı kesintilerinde veri kaybı riski azaltıldı.
- Wrangler `SOCIAL` binding ve Durable Object migration eklendi.
- Paket sürümü `22.0.0` yapıldı.
- `ZATO_PROJECT_CONTEXT.md` V22 durumuna göre güncellendi.

## Doğrulama

- TypeScript/Cloudflare Worker yapısal kontrolleri yapıldı.
- Tam npm build, önceki sürümlerde olduğu gibi bağımlılıkların ortamda kurulu/indirilebilir olmasına bağlıdır.
