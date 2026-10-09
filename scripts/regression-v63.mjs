import fs from 'node:fs';
const pkg=JSON.parse(fs.readFileSync('package.json','utf8'));
const w=fs.readFileSync('worker/index.ts','utf8');
const m=fs.readFileSync('db/migrations/V63.sql','utf8');
const checks=[
 ['version',pkg.version==='63.0.0'],
 ['script',pkg.scripts['regression:v63']==='node scripts/regression-v63.mjs'],
 ['migration',m.includes('tournament_share_export_keys')&&m.includes('tournament_share_maintenance_replays')],
 ['hmac',w.includes('hmacSha256Hex')&&w.includes('SHARE_EXPORT_SIGNING_SECRET')],
 ['export-v63',w.includes("exportVersion:'v63'")&&w.includes("signatureAlgorithm:'HMAC-SHA256'")],
 ['maintenance-replay',w.includes('tournamentShareMaintenanceReplay')&&w.includes("mode:'dry-run'")],
 ['alert-filter',w.includes('tournamentShareAlertAudit')&&w.includes("searchParams.get('alert')")],
 ['readiness',w.includes("v63:'export-signature-key-rotation-alert-audit-filters-maintenance-replay-route-contracts'")]
];
for(const [name,ok] of checks) if(!ok) throw new Error(`V63 regression failed: ${name}`);
console.log('V63 regression OK');
