# V24 — PRESENCE 2.0

- Arkadaş API’si artık `last_seen_at` döndürüyor.
- Çevrimiçi durumu 45 saniyelik heartbeat eşiğini koruyor.
- Sosyal arayüz çevrimdışı kullanıcı için son görülme bilgisini insan okunur biçimde gösteriyor.
- Mevcut oyun daveti/online gating davranışı korunuyor.
- Heartbeat 20 saniyede devam ediyor; mevcut sosyal WebSocket ve polling fallback değişmedi.
