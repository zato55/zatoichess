import fs from 'node:fs';
const pkg=JSON.parse(fs.readFileSync('package.json','utf8'));
const w=fs.readFileSync('worker/index.ts','utf8');
const m=fs.readFileSync('db/migrations/V78.sql','utf8');
const checks=[
 pkg.version==='78.0.0', pkg.scripts['regression:v78'],
 m.includes('tournament_share_verification_exports'),m.includes('tournament_share_policy_drift_alerts'),m.includes('tournament_share_verification_replays'),
 w.includes('exports-v78'),w.includes('policy-drift-alerts-v78'),w.includes('replay-v78'),
 w.includes("v78:'signed-verification-history-export-policy-drift-alerts-scheduled-verification-replay'"),w.includes("version:'78.0.0'")
];
if(checks.some(x=>!x)) throw new Error('V78 regression failed');
console.log('V78 regression OK');
