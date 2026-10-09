const fs = require('fs');
const file = 'worker/index.ts';
let content = fs.readFileSync(file, 'utf8');

let changes = 0;
const log = (n, ok) => { console.log((ok ? '✅ ' : '❌ ') + 'Fix ' + n + (ok ? ' uygulandı' : ' BULUNAMADI')); if (ok) changes++; };

// Fix 1: /ws/CODE - original request'i geçir
const old1 = "const fwdHeaders=new Headers(); fwdHeaders.set('Upgrade','websocket'); fwdHeaders.set('x-zato-user-id',user.id); fwdHeaders.set('x-zato-username',user.username); fwdHeaders.set('x-zato-display-name',user.display_name); fwdHeaders.set('x-zato-rating',String(user.rating)); const forwarded=new Request(request.url,{method:'GET',headers:fwdHeaders});";
const new1 = "const _turl=new URL(request.url); _turl.searchParams.set('_uid',user.id); _turl.searchParams.set('_uname',user.username); _turl.searchParams.set('_dname',user.display_name); _turl.searchParams.set('_rating',String(user.rating)); const forwarded=new Request(_turl.toString(),request);";
if (content.includes(old1)) { content = content.replace(old1, new1); log(1, true); } else log(1, false);

// Fix 2: spectator header
const old2 = "if(spectator)fwdHeaders.set('x-zato-spectator','1');";
const new2 = "if(spectator)_turl.searchParams.set('_spec','1');";
if (content.includes(old2)) { content = content.replace(old2, new2); log(2, true); } else log(2, false);

// Fix 3: turnuva forwarding
const old3 = "const u=new URL(forwarded.url); u.searchParams.set('timeControl',tm.time_control); return env.ROOMS.get(env.ROOMS.idFromName(code)).fetch(new Request(u,forwarded));";
const new3 = "_turl.searchParams.set('timeControl',tm.time_control); const fwd2=new Request(_turl.toString(),request); return env.ROOMS.get(env.ROOMS.idFromName(code)).fetch(fwd2);";
if (content.includes(old3)) { content = content.replace(old3, new3); log(3, true); } else log(3, false);

// Fix 4: RoomDurableObject - query paramlardan oku
const old4 = "const userId=request.headers.get('x-zato-user-id'); const username=request.headers.get('x-zato-username')||''; const displayName=request.headers.get('x-zato-display-name')||username; const rating=Number(request.headers.get('x-zato-rating')||1200);";
const new4 = "const _u=new URL(request.url); const userId=_u.searchParams.get('_uid')||request.headers.get('x-zato-user-id'); const username=_u.searchParams.get('_uname')||request.headers.get('x-zato-username')||''; const displayName=_u.searchParams.get('_dname')||request.headers.get('x-zato-display-name')||username; const rating=Number(_u.searchParams.get('_rating')||request.headers.get('x-zato-rating')||1200);";
if (content.includes(old4)) { content = content.replace(old4, new4); log(4, true); } else log(4, false);

// Fix 5: spectator query param
const old5 = "const spectator=request.headers.get('x-zato-spectator')==='1';";
const new5 = "const spectator=new URL(request.url).searchParams.get('_spec')==='1'||request.headers.get('x-zato-spectator')==='1';";
if (content.includes(old5)) { content = content.replace(old5, new5); log(5, true); } else log(5, false);

console.log('');
console.log('Toplam:', changes, '/ 5');

if (changes === 5) {
  fs.writeFileSync(file + '.ws-backup', fs.readFileSync(file, 'utf8'));
  fs.writeFileSync(file, content, 'utf8');
  console.log('');
  console.log('🎉 TÜM DÜZELTMELER YAPILDI!');
  console.log('Yedek: worker/index.ts.ws-backup');
} else {
  console.log('');
  console.log('⚠️ Bazı düzeltmeler bulunamadı. Dosya DEĞİŞTİRİLMEDİ.');
  console.log('Lütfen yukarıdaki ❌ satırlarına bak.');
}