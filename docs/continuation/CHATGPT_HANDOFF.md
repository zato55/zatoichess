# ZATO Chess — ChatGPT Devam Notu

> **Amaç:** Bu dosya, yeni bir ChatGPT sohbetinde ZATO Chess projesini devralan modele/kişiye projenin mevcut durumunu, mimarisini, en son yapılanları ve sıradaki işi hızlıca anlatmak için tutulur.
>
> **Kaynak doğruluğu:** Bu not, V93 sonrası 8 Ekim 2026 durumuna göre güncellenmiştir. Gerçek Cloudflare/D1 durumu kullanıcı tarafından Dashboard/Console üzerinden doğrulanmıştır.

## 1. Proje nedir?

ZATO Chess; React + TypeScript + Vite frontend, Cloudflare Worker backend, Cloudflare D1 kalıcı veri tabanı ve Durable Objects kullanan kapsamlı bir satranç platformudur.

Ana özellik katmanları arasında local chess, Stockfish 19 analiz, hesap/oturum, ELO, online odalar, WebSocket canlı oyun, spectator, arkadaşlık/sosyal bildirimler, matchmaking, arena/cup, turnuvalar, turnuva paylaşımı/replay/cache ve bakım/retention sistemleri bulunur.

## 2. Ana mimari

- `src/App.tsx`: ana React uygulaması ve büyük UI/state akışı.
- `src/styles.css`: ana UI/CSS.
- `src/engine/stockfish.ts`: Stockfish 19 Web Worker.
- `src/lib/gameStorage.ts`: local oyun saklama.
- `src/lib/profileStorage.ts`: profil/ELO local saklama.
- `worker/index.ts`: Cloudflare Worker API + WebSocket yönlendirmesi.
- Durable Objects: `RoomDurableObject`, `SocialDurableObject`, `MatchmakingDurableObject`.
- `db/schema.sql`: temel schema.
- `db/migrations/`: tarihsel migration zinciri; V31–V85 dahil.
- `db/D1_INITIAL_SETUP_V93.sql`: boş D1 için hazırlanmış birleşik başlangıç SQL paketi.
- `scripts/`: regression, release gate, contract ve production evidence araçları.
- `docs/continuation/`: proje devam/handoff kayıtlarının ana yeri.
- `docs/releases/`: sürüm/release belgeleri.

## 3. En son tamamlanan sürüm

**V93**.

V93 yeni kullanıcı özelliği ekleyen bir sürüm değildir. Ana amacı eksik paketlenmiş migration setini geri koymak ve 1.0 öncesi dağıtım/migration bütünlüğünü güvenceye almaktır.

V93 paketinde migration zinciri korunmuştur. Bundan sonra yeni özellik geliştirmek yerine gerçek production doğrulamasına geçilmesi gerekir.

## 4. Gerçek D1 durumu — GÜNCEL

Cloudflare Dashboard'da kullanıcı tarafından oluşturulan gerçek D1:

- **Database adı:** `zato-chess`
- **Database ID:** `3bc201ad-5257-4c1d-9454-17431f48dcc2`
- **Durum:** boş / migration uygulanmamış.

Cloudflare D1 Console'da şu kontroller yapıldı:

```sql
SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name;
```

Sonuç yalnızca Cloudflare'ın `_cf_KV` iç tablosunu gösterdi.

Ardından:

```sql
SELECT name
FROM sqlite_master
WHERE type = 'table'
  AND name NOT LIKE '_cf_%'
ORDER BY name;
```

Sonuç: **No data**.

Dashboard da `Number of Tables: 0`, `Total queries: 0`, `Rows written: 0` gösterdi.

**Sonuç:** `zato-chess` uygulama açısından temiz/boş bir başlangıç D1'idir. Henüz migration çalıştırılmadı.

## 5. Kullanıcıyla en son yapılan işlem

Kullanıcı Cloudflare D1 Console'u açtı ve yukarıdaki boşluk kontrollerini yaptı.

Ardından V93 projesi GitHub'a aktarılmaya hazırlanmak üzere temizlendi. GitHub'a uygun ZIP hazırlanmıştır. ZIP'te gereksiz yerel artefact'lar ve secret/env dosyaları çıkarılmıştır; kaynak kod, migration, docs ve scriptler korunmuştur.

**Önemli:** GitHub'a ZIP dosyasının kendisi değil, ZIP açıldıktan sonra içindeki `project/` klasörünün içeriği repository köküne konmalıdır. Böylece repository kökünde doğrudan `src/`, `worker/`, `db/`, `scripts/`, `docs/`, `package.json`, `wrangler.toml` vb. bulunur.

## 6. Şu anda yapılmaması gerekenler

- Yeni kullanıcı özelliği geliştirmeye başlama.
- `zato-chess` D1'e rastgele/elle SQL yazma.
- Migration sırasını atlama veya dosyaları yeniden numaralandırma.
- Gerçek secret/API token'ları sohbete veya GitHub'a yazma.
- Production doğrulaması yapılmadan 1.0 ilan etme.

## 7. SIRADAKİ İŞ — tam olarak buradan devam et

### A. GitHub kaynağını doğrula

1. Kullanıcının GitHub repository linkini al.
2. Repository'nin V93 ZIP ile uyumunu kontrol et.
3. Kök yapının doğru olduğunu doğrula.
4. `wrangler.toml` içindeki D1 binding'i kontrol et.
5. D1 database ID placeholder ise gerçek ID ile eşleştir:

```toml
database_id = "3bc201ad-5257-4c1d-9454-17431f48dcc2"
```

Secret değerleri repo'ya koyma.

### B. Migration'ları gerçek D1'e uygula

Hedef: boş `zato-chess` D1 üzerinde V93 migration zincirini doğru sırayla çalıştırmak.

Tercih edilen yol: repository'deki migration dosyaları ve Wrangler ile **remote D1** migration akışını kullanmak. Console'a büyük birleşik SQL'i körlemesine yapıştırmak tercih edilmez.

Uygulama öncesi migration listesini tekrar kontrol et.

### C. Migration sonrası doğrulama

Gerçek D1 Console'da:

- tablo sayısını kontrol et,
- kritik tabloların varlığını kontrol et,
- migration durumunu doğrula,
- index/constraint hatası olmadığını kontrol et.

Migration başarılı olmadan Worker deploy aşamasına geçme.

### D. Worker bağlantısı ve deploy

D1 binding doğruysa Worker build/check çalıştırılır ve gerçek Cloudflare ortamına deploy edilir.

Sonra gerçek Worker sağlık/API rotaları kontrol edilir.

### E. Gerçek tarayıcı doğrulaması

En azından:

1. auth/session
2. online oda
3. WebSocket hamle akışı
4. rematch
5. social/friend/invite/notification
6. matchmaking
7. arena/cup
8. 4/8 kişilik tournament
9. spectator
10. public tournament share/replay/cache/ETag
11. maintenance/retention
12. push notification
13. desktop + dar ekran

akışları gerçek ortamda test edilmelidir.

### F. Production evidence ve 1.0

Kod testlerinin PASS olması tek başına production PASS değildir.

Üç kapı ayrı tutulmalı:

- `CODE_READY`
- `PRODUCTION_CONFIGURED`
- `PRODUCTION_RUNTIME_VALIDATED`

Üçü de PASS olmadan `1.0` onaylanmamalıdır.

## 8. Yeni sohbet açıldığında modele verilecek talimat

Yeni sohbette önce şu dosyalar okunmalı:

1. `docs/continuation/CHATGPT_HANDOFF.md` ← **ilk ve en önemli dosya**
2. `docs/continuation/ZATO_PROJECT_CONTEXT.md`
3. `docs/continuation/CURRENT_STATE.md`
4. `docs/continuation/NEXT_STEPS.md`
5. `docs/continuation/DEPLOYMENT_RUNBOOK.md`
6. ilgili release/checklist belgeleri

Ardından kullanıcıya proje durumunu tekrar sordurma. Özellikle şu gerçekleri kabul et:

- V93 mevcut kaynak tabanıdır.
- `zato-chess` D1 oluşturulmuştur.
- D1 ID `3bc201ad-5257-4c1d-9454-17431f48dcc2`.
- D1 uygulama tabloları açısından boştur.
- Migration henüz uygulanmamıştır.
- Sıradaki ana iş migration → doğrulama → Worker → browser production testidir.
- Yeni özellik geliştirme 1.0 production doğrulamasına kadar dondurulmuştur.

## 9. Sürüm devam kuralı

Her yeni ZIP/release içinde bu handoff/continuation bilgisi güncellenmelidir.

Yeni sürümde mutlaka şu bilgiler yazılmalıdır:

- sürüm numarası,
- en son yapılan değişiklikler,
- gerçek ortam durumu,
- tamamlanan testler,
- bilinen eksikler,
- sıradaki mantıklı adım,
- yeni sohbette okunması gereken dosyalar.

Bu dosya, projenin sohbetler arasında sürekliliğini sağlamak için tutulur.
