import fs from 'node:fs';
const pkg=JSON.parse(fs.readFileSync('package.json','utf8'));
const w=fs.readFileSync('worker/index.ts','utf8');
const m=fs.readFileSync('db/migrations/V68.sql','utf8');
const checks=[
 ['version',pkg.version==='68.0.0'],['script',pkg.scripts['regression:v68']==='node scripts/regression-v68.mjs'],
 ['summary-table',m.includes('tournament_share_contract_replay_summary')],['chain-table',m.includes('tournament_share_key_audit_chain')],
 ['summary-route',w.includes('tournamentShareContractSummary')],['chain-route',w.includes('tournamentShareKeyChain')],
 ['readiness',w.includes("v68:'contract-evidence-summary-key-audit-chain-runtime-contract-diagnostics'")],
 ['worker-version',w.includes("version:'68.0.0'")]
];
for(const [n,ok] of checks) if(!ok) throw new Error(n); console.log('V68 regression OK');
