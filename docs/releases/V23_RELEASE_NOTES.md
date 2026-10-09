# ZATO Chess V23 — Notification UX

## Added
- Bildirimler artık tek tek `Okundu` yapılabiliyor.
- `Tümünü okundu yap` korunuyor.
- `Görüntüle` aksiyonu bildirim tipine göre ilgili sosyal bölüme yönlendiriyor.
- Oyun daveti bildirimleri gelen oyun davetleri bölümüne götürüyor.
- Arkadaşlık olayları arkadaşlar bölümüne yönlendiriliyor.
- Gönderilmiş oyun daveti sonucu bildirimleri gönderilen davetler bölümüne götürüyor.
- Bildirim listesi 12 öğeye kadar daha kullanışlı aksiyonlarla gösteriliyor.
- Sosyal modal açılırken bildirimler artık otomatik olarak topluca okundu sayılmıyor.

## Technical
- Mevcut `POST /api/notifications/read` endpoint'in tekil `id` desteği UI'dan aktif kullanılıyor.
- Bildirim payload'ı V22'deki olay metadata'sıyla korunuyor.
- WebSocket push + 30 saniyelik fallback mimarisi aynen korunuyor.

## Known limitations
- Deep link uygulama içi sosyal modal bölümlerine yönlendirme seviyesindedir; ileride ayrı profil/maç ekranlarına genişletilebilir.
- Native browser push notification henüz yoktur.
- Tam dependency/build doğrulaması npm paketlerinin çalışma ortamında kurulu olmasına bağlıdır.
