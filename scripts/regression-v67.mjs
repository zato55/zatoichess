import fs from 'node:fs';
const pkg=JSON.parse(fs.readFileSync('package.json','utf8')); const w=fs.readFileSync('worker/index.ts','utf8'); const m=fs.readFileSync('db/migrations/V67.sql','utf8');
const checks=[
 ['version',pkg.version==='67.0.0'],['regression-script',pkg.scripts['regression:v67']==='node scripts/regression-v67.mjs'],
 ['evidence-table',m.includes('tournament_share_contract_replay_evidence')],['key-audit-table',m.includes('tournament_share_key_rotation_audit')],['maintenance-run-table',m.includes('tournament_share_maintenance_replay_runs')],
 ['evidence-route',w.includes('tournamentShareContractEvidence')],['key-audit-route',w.includes('tournamentShareKeyAudit')],['maintenance-run-route',w.includes('tournamentShareMaintenanceReplayRuns')],
 ['export-v67',w.includes("exportVersion:'v67'")],['readiness',w.includes("v67:'contract-replay-evidence-key-rotation-audit-deterministic-maintenance-replay'")]
];
for(const [n,ok] of checks) if(!ok) throw new Error(n); console.log('V67 regression OK');
