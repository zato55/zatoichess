# ZATO Chess V84 — Sürüm Notları

## Amaç
V83 saklama/doğrulama zincirinin son operasyonel bağlantılarını tamamlamak ve 1.0 sertleştirmesine geçiş için ölçülebilir bir kontrol katmanı eklemek.

## Yapılanlar
- Doğrulama geçmişi ile saklama replay sonuçlarını karşılaştıran V84 kayıtları.
- Politika olaylarının çözüm/işlem kanıtlarını bütünlük özetiyle saklama.
- Zamanlanmış saklama replay sağlık özeti ve geçmiş istatistikleri.
- Sahip ekranında V84 son doğrulama paneli.
- Hazır olma yanıtı V84'e yükseltildi.

## Güvenlik
- Tüm V84 kayıtları turnuva sahibi erişimiyle korunur.
- Yeni kayıtların SHA-256 bütünlük özeti tutulur.
- Replay gerçek veri silmez; yalnızca adayları ve sonuçları ölçer.
