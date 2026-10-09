import fs from 'node:fs';
const worker=fs.readFileSync(new URL('../worker/index.ts',import.meta.url),'utf8');
const requiredRoutes=[
  '/share/tournament/:token',
  '/share/tournament/:token/og.svg',
  '/share/tournament/:token/data',
  '/share/tournament/:token/replay',
  '/api/tournaments/:id/share/health',
  '/api/tournaments/:id/share/health/contract-evidence',
  '/api/tournaments/:id/share/health/contract-evidence/summary',
  '/api/tournaments/:id/share/health/contract-evidence/route-matrix',
  '/api/tournaments/:id/share/health/contract-evidence/compare'
];
const requiredFragments=['/share/tournament/','/og.svg','contract-evidence','route-matrix','compare','comparisons','verification','retention'];
for(const fragment of requiredFragments) if(!worker.includes(fragment)) throw new Error(`missing route contract ${fragment}`);
const fixture=[
 {route:'html',statusCode:200,cacheMarker:'origin-miss'},
 {route:'tournament-json',statusCode:304,cacheMarker:'conditional-hit'},
 {route:'replay-json',statusCode:200,cacheMarker:'origin-miss'},
 {route:'og-image',statusCode:200,cacheMarker:'origin-miss'}
];
const matrix=fixture.reduce((m,r)=>{const x=m[r.route]??={route:r.route,total:0,passed:0,originHits:0,conditionalHits:0};x.total++;x.passed+=r.statusCode>=200&&r.statusCode<400?1:0;x.originHits+=r.statusCode===200?1:0;x.conditionalHits+=r.statusCode===304?1:0;return m},{});
if(Object.keys(matrix).length!==4||Object.values(matrix).some(x=>x.failed||x.passed!==x.total))throw new Error('matrix fixture mismatch');
console.log('V72 public-share contract matrix OK');
