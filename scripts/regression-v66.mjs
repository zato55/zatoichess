import fs from 'node:fs';
const pkg=JSON.parse(fs.readFileSync('package.json','utf8'));
const w=fs.readFileSync('worker/index.ts','utf8');
const m=fs.readFileSync('db/migrations/V66.sql','utf8');
const fixture=JSON.parse(fs.readFileSync('scripts/fixtures/v66-route-contracts.json','utf8'));
const checks=[
 ['version',pkg.version==='66.0.0'],
 ['migration-tables',m.includes('tournament_share_contract_replays')&&m.includes('tournament_share_key_rotation_runs')],
 ['runtime-script',pkg.scripts['test:runtime-contract:v66']==='node scripts/runtime-contract-v66.mjs'],
 ['rotation-script',pkg.scripts['test:key-rotation:v66']==='node scripts/key-rotation-v66.mjs'],
 ['fixture-routes',fixture.contracts.length===4&&fixture.contracts.every(x=>x.fresh.status===200&&x.conditional.status===304)],
 ['cache-headers',w.includes('x-zato-cache')&&w.includes('conditional-hit')&&w.includes('origin-miss')],
 ['readiness',w.includes("version:'66.0.0'")&&w.includes("v66:'runtime-route-cache-replay-key-rotation-verification-contracts'")],
 ['docs-structure',fs.existsSync('docs/releases/V66_RELEASE_NOTES.md')&&fs.existsSync('docs/continuation/ZATO_PROJECT_CONTEXT.md')]
];
for(const [name,ok] of checks)if(!ok)throw new Error(`V66 regression failed: ${name}`);
console.log('V66 regression OK');
