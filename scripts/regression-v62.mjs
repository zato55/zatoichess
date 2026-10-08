import fs from 'node:fs';
const worker=fs.readFileSync('worker/index.ts','utf8');
const app=fs.readFileSync('src/App.tsx','utf8');
const migration=fs.readFileSync('db/migrations/V62.sql','utf8');
const pkg=JSON.parse(fs.readFileSync('package.json','utf8'));
const checks=[
 ['version 62',pkg.version==='62.0.0'],
 ['migration ack audit',migration.includes('tournament_share_alert_ack_audit')],
 ['migration maintenance errors',migration.includes('tournament_share_maintenance_errors')],
 ['migration maintenance metadata',migration.includes('tournament_share_maintenance_run_meta')],
 ['maintenance status',worker.includes("status:errors.length?'partial':'ok'")&&worker.includes('error_count')],
 ['maintenance step telemetry',worker.includes("maintenance-error-persist")&&worker.includes("maintenance-meta-persist")],
 ['maintenance diagnostics v62',worker.includes("version:'v62'")&&worker.includes('maintenance_errors')&&worker.includes('maintenance_run_meta')],
 ['ack audit write',worker.includes('INSERT INTO tournament_share_alert_ack_audit')],
 ['cache hit rate',worker.includes('hitRate:total?Math.round(conditional*10000/total)/100:0')],
 ['export v62',worker.includes("exportVersion:'v62'")&&worker.includes("schemaVersion:'1.1'")],
 ['export cache summary',worker.includes('cacheSummary')],
 ['export ack audit',worker.includes('alertAudit')],
 ['frontend sha verify',app.includes('sha256Json')&&app.includes('verified')&&app.includes('SHA-256 doğrulaması')],
 ['frontend maintenance errors',app.includes('share-maintenance-error')&&app.includes('kısmi hata')]
];
for(const [name,ok] of checks) if(!ok) throw new Error(`V62 regression failed: ${name}`);
console.log('V62 regression OK');
