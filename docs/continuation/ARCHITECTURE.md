# ZATO Chess — Mimari Özeti V86

## İstemci
React + TypeScript + Vite. `src/App.tsx` ana kullanıcı arayüzünü, `src/styles.css` görünümü taşır.

## Sunucu
Cloudflare Worker: `worker/index.ts`.

## Kalıcı veri
Cloudflare D1 ve `db/migrations/` altındaki sürümlü göçler.

## Gerçek zamanlı katman
`ROOMS`, `SOCIAL`, `MATCHMAKING` Durable Object'leri.

## Güvenlik
HttpOnly oturum çerezi, sahibi doğrulanan yönetim rotaları, token hashleme, süre sonu, iptal, hız sınırlama ve bütünlük imzaları.

## V86 notu
Bu sürüm yeni mimari katman eklememiştir. Amaç Worker kaynak ağacındaki ayrıştırma sorunlarını temizleyerek 1.0 öncesi güvenilir bir taban oluşturmaktır.


V91 notu: 1.0 için gerçek üretim kanıtı bekleniyor; yeni özellik geliştirme donduruldu.
