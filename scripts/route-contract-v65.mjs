import fs from 'node:fs';
const w=fs.readFileSync('worker/index.ts','utf8');
const contracts=[
 ['/share/health/export/verify','POST','hashVerified','signatureVerified'],
 ['/share/health/keys','GET','events','HMAC-SHA256'],
 ['/share/health/keys','POST','Aktif deploy anahtarı önce yeni key ile değiştirilmelidir.','Yalnızca yapılandırılmış signing key etkinleştirilebilir.'],
 ['/share/health/maintenance/replay','POST','previousReplayId','tournament_share_maintenance_replay_diffs'],
 ['/share/health/maintenance/replay/history','GET','diffJson','previousReplayId'],
 ['/share/health/alerts/audit','GET','nextBefore','hasMore'],
];
for(const [route,method,...needles] of contracts){for(const n of needles)if(!w.includes(n))throw new Error(`V65 route contract failed: ${method} ${route} missing ${n}`)}
for(const n of ['x-zato-cache','conditional-hit','origin-miss','cache-control','must-revalidate'])if(!w.includes(n))throw new Error(`V65 cache header contract failed: ${n}`);
console.log(`V65 route/cache contract matrix OK (${contracts.length} route contracts)`);
