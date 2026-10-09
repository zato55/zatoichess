import fs from 'node:fs';
const pkg=JSON.parse(fs.readFileSync('package.json','utf8'));
const w=fs.readFileSync('worker/index.ts','utf8');
const m=fs.readFileSync('db/migrations/V64.sql','utf8');
const checks=[
 ['version',pkg.version==='64.0.0'],
 ['script',pkg.scripts['regression:v64']==='node scripts/regression-v64.mjs'],
 ['migration',m.includes('tournament_share_export_key_events')&&m.includes('idx_tournament_share_export_key_events_key_created')],
 ['verify-route',w.includes('tournamentShareVerify')&&w.includes('hashVerified')&&w.includes('signatureVerified')],
 ['key-lifecycle',w.includes('tournamentShareKeyLifecycle')&&w.includes('tournament_share_export_key_events')],
 ['key-config',w.includes('SHARE_EXPORT_SIGNING_KEY_ID')&&w.includes('HMAC-SHA256')],
 ['replay-diff',w.includes('previousPlan')&&w.includes('delta')&&w.includes("version:'v64',mode:'dry-run'")],
 ['alert-pagination',w.includes('nextBefore')&&w.includes('before')&&w.includes('hasMore')],
 ['export-v64',w.includes("exportVersion:'v64'")&&w.includes('signatureConfigured')],
 ['readiness',w.includes("v64:'signed-export-verification-key-lifecycle-replay-diff-alert-pagination-route-matrix'")]
];
for(const [name,ok] of checks) if(!ok) throw new Error(`V64 regression failed: ${name}`);
console.log('V64 regression OK');
