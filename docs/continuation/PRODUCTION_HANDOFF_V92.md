# ZATO Chess V92 — Üretim Devir Paketi

Bu belge, başka bir hesapta veya yeni bir sohbette projeyi devralan kişi/model için başlangıç noktasıdır.

## Mevcut durum
V92, V91 yayın adayını temel alan 1.0 geçiş sözleşmesidir. Yeni kullanıcı özelliği geliştirme dondurulmuştur.

## Önemli kural
Gerçek Cloudflare/D1/Worker/tarayıcı erişimi olmadan üretim doğrulaması PASS kabul edilmez.

## İlk yapılacaklar
1. `ZATO_PROJECT_CONTEXT.md` oku.
2. `CURRENT_STATE.md` ve `NEXT_STEPS.md` oku.
3. `DEPLOYMENT_RUNBOOK.md` oku.
4. `V92_PRODUCTION_CHECKLIST.md` içindeki gerçek ortam maddelerini uygula.
5. Kanıtları tek manifestte topla.
6. Kanıtların tamamı yoksa 1.0 ilan etme.

## Kullanıcıdan istenecekler
Yalnızca gerçek dağıtım gerektiğinde Cloudflare proje erişimi, D1, alan adı ve üretim ortamı için gereken gizli değişkenlerin güvenli ortam yapılandırması istenir. Gizli değerler ZIP'e veya kaynak koda yazılmaz.

## Sonraki mantıklı adım
V92 sonrası yeni özellik sürümü açma. Gerçek üretim ortamı doğrulamasına geç. Sorun çıkarsa yalnızca düzeltme sürümü oluştur; sorun yoksa 1.0 sürümünü paketle.
