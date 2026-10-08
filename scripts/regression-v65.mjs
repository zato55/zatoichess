import fs from 'node:fs';
const pkg=JSON.parse(fs.readFileSync('package.json','utf8'));
const w=fs.readFileSync('worker/index.ts','utf8');
const m=fs.readFileSync('db/migrations/V65.sql','utf8');
const a=fs.readFileSync('src/App.tsx','utf8');
const checks=[
 ['version',pkg.version==='65.0.0'],['migration',m.includes('tournament_share_maintenance_replay_diffs')&&m.includes('tournament_share_route_contract_runs')],
 ['rotation-harness',pkg.scripts['test:signature-rotation:v65']==='node scripts/signature-rotation-v65.mjs'],
 ['route-harness',pkg.scripts['test:route-contract:v65']==='node scripts/route-contract-v65.mjs'],
 ['key-events',w.includes('tournament_share_export_key_events')&&w.includes('events')],
 ['verify-reason',w.includes('hash-mismatch')&&w.includes('signature-invalid')&&w.includes('signature-not-configured')],
 ['replay-persistence',w.includes('tournament_share_maintenance_replay_diffs')&&w.includes('previousReplayId')],
 ['replay-history',w.includes('tournamentShareReplayHistory')&&w.includes('diffJson')],
 ['cache-contract',w.includes('x-zato-cache')&&w.includes('conditional-hit')&&w.includes('origin-miss')],
 ['ui-key-events',a.includes('share-key-events')&&a.includes('tournamentShareKeyState.events')],
 ['ui-replay-history',a.includes('share-maintenance-replay-history')&&a.includes('tournamentShareReplayHistory')],
 ['readiness',w.includes("version:'65.0.0'")&&w.includes("v65:'signature-rotation-harness-replay-diff-persistence-route-contract-cache-header-tests'")]
];
for(const [name,ok] of checks)if(!ok)throw new Error(`V65 regression failed: ${name}`);
console.log('V65 regression OK');
