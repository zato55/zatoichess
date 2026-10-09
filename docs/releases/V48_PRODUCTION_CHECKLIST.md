# ZATO Chess V48 — Production Checklist

1. V47 production migration durumunu doğrula; V48 için ek migration yoktur.
2. Worker/D1/DO binding'lerini mevcut production konfigürasyonuyla deploy et.
3. `/api/system/status` sürümünün 48.0.0 döndürdüğünü doğrula.
4. Bitmiş bir turnuvada tournament detail aç.
5. Viewer'ın rakip karşılaştırmasının yalnızca kendi eşleşmelerini gösterdiğini doğrula.
6. Replay tie-break maçlarının karşılaştırmada tie-break olarak işaretlendiğini doğrula.
7. Turnuva özetini panoya kopyala ve URL'nin dahil olduğunu doğrula.
8. Şampiyon/ikinci sonuç özetinin doğru olduğunu doğrula.
9. Eski V42–V47 turnuvalarının detail/history ekranlarının açıldığını doğrula.
10. ELO/rating_history/season istatistiklerinin replay tie-break tarafından değişmediğini doğrula.
11. Rollback için V47 ZIP'ini sakla.

Not: Gerçek production deployment bu sürüm kapsamında yapılmamıştır.
