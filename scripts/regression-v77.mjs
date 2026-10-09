import fs from 'node:fs';
const pkg=JSON.parse(fs.readFileSync('package.json','utf8'));
const w=fs.readFileSync('worker/index.ts','utf8');
const m=fs.readFileSync('db/migrations/V77.sql','utf8');
for(const x of [pkg.version==='77.0.0',pkg.scripts['regression:v77'],m.includes('tournament_share_key_chain_verification_history'),m.includes('tournament_share_contract_snapshot_diffs'),m.includes('tournament_share_policy_drift_history'),w.includes('chain\\/verify-v77'),w.includes('snapshot-diff-v77'),w.includes('policy-drift-v77'),w.includes("version:'77.0.0'"),w.includes("v77:'key-chain-verification-snapshot-diff-policy-drift-history'")]) if(!x) throw new Error('V77 regression failed');
console.log('V77 regression OK');
