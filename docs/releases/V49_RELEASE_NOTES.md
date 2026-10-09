# ZATO Chess V49 — Release Notes

## Ana değişiklikler
- Turnuvalar için kalıcı public share token sistemi eklendi.
- Ham token yalnızca oluşturma yanıtında verilir; D1'de yalnızca SHA-256 hash saklanır.
- `POST /api/tournaments/:id/share` yeni public paylaşım linki üretir ve önceki aktif linki güvenli biçimde iptal eder.
- `DELETE /api/tournaments/:id/share` turnuva sahibinin public linki iptal etmesini sağlar.
- `GET /api/public/tournaments/:token` auth gerektirmeyen, salt-okunur turnuva JSON'u sağlar.
- `GET /api/public/tournaments/:token/replay/:gameId` yalnızca ilgili paylaşılan turnuvaya ait tamamlanmış maçı ve hamleleri açar.
- `/share/tournament/:token` public, server-rendered sonuç/bracket sayfasıdır.
- Public sayfada Open Graph başlık/açıklama/URL metadata'sı bulunur.
- Bracket satırları replay deep-link'i taşır; replay seçildiğinde PGN ve hamle akışı salt-okunur gösterilir.
- Public share katmanı oda kodlarını, özel kullanıcı verilerini veya oyun oynama yetkisini dışarı açmaz.
- Worker/API/package sürümü `49.0.0`.

## Güvenlik
- Share token rastgele 256-bit değer olarak üretilir.
- Token veritabanında hash olarak tutulur.
- İptal edilmiş tokenlar hem JSON hem HTML public uçlarında reddedilir.
- Replay erişimi token + tournament match + finished game ilişkisiyle sınırlandırılır.

## Validation
- `node scripts/regression-v49.mjs` → V49 regression OK
- V48 ve önceki tournament migration zinciri korunur.
- Tam npm/Vite production build, bu çalışma ortamında bağımlılıklar kurulu olmadığı için çalıştırılmadı.
