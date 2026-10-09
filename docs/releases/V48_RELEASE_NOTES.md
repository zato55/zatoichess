# ZATO Chess V48 — Release Notes

## Ana değişiklikler
- Tournament detail içinde viewer'a göre gerçek head-to-head rakip karşılaştırması.
- Turnuva giriş rating snapshot'ları üzerinden karşılaştırma; güncel rating'e bağımlı değil.
- Tie-break sayısı ve G/B/M özeti rakip bazında gösteriliyor.
- Paylaşılabilir turnuva sonuç özeti: şampiyon, oyuncu sayısı, tamamlanan maç ve tie-break sayısı.
- Paylaşım metni mevcut sayfa URL'si ile panoya alınır; sunucuya gereksiz yeni kayıt yazılmaz.
- Worker/API sürümü 48.0.0.

## Rating güvenliği
Replay tie-break maçları V45'ten beri ELO/rating_history/sezon rekabet istatistiklerinden ayrıdır; V48 bu ayrımı yalnızca görünür analytics tarafında kullanır.

## Validation
- `node scripts/regression-v48.mjs` → V48 regression OK
- Önceki V47 migration zinciri korunur; V48'te yeni DB migration gerektiren tablo/kolon değişikliği yoktur.
- Tam npm/Vite build, bağımlılıkların bu çalışma ortamında kurulu olmaması nedeniyle çalıştırılmadı.
