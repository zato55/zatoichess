import fs from 'node:fs';
const worker=fs.readFileSync('worker/index.ts','utf8');
const app=fs.readFileSync('src/App.tsx','utf8');
const migration=fs.readFileSync('db/migrations/V61.sql','utf8');
const pkg=JSON.parse(fs.readFileSync('package.json','utf8'));
const checks=[
  ['version 61',pkg.version==='61.0.0'],
  ['migration alert ack rebuild',migration.includes('tournament_share_alert_ack_v61')&&migration.includes('acknowledged_occurrences')],
  ['maintenance table',migration.includes('tournament_share_maintenance_runs')],
  ['maintenance persistence',worker.includes('INSERT INTO tournament_share_maintenance_runs')],
  ['maintenance diagnostics route',worker.includes('share\\/health\\/maintenance')],
  ['export v61',worker.includes("exportVersion:'v61'")],
  ['export integrity',worker.includes('shareExportIntegrity')],
  ['alert lifecycle occurrence',worker.includes('acknowledged_occurrences')],
  ['frontend export verification',app.includes('tournamentShareExportMeta')&&app.includes('Export doğrulama')],
  ['frontend maintenance diagnostics',app.includes('tournamentShareMaintenance')&&app.includes('Bakım tanılaması')],
  ['frontend recurring acknowledgement',app.includes('acknowledgedOccurrences')]
];
for(const [name,ok] of checks) if(!ok) throw new Error(`V61 regression failed: ${name}`);
console.log('V61 regression OK');
