import fs from 'node:fs';
const w=fs.readFileSync('worker/index.ts','utf8');
const m=fs.readFileSync('db/migrations/V81.sql','utf8');
const p=JSON.parse(fs.readFileSync('package.json','utf8'));
const checks=[
 p.version==='81.0.0',
 m.includes('tournament_share_verification_chain_export_checks'),
 m.includes('tournament_share_policy_alert_audit_chain'),
 m.includes('tournament_share_cleanup_comparison_history'),
 m.includes('tournament_share_retention_remediation'),
 w.includes('chain-export-v81'),
 w.includes('policy-alerts-v81'),
 w.includes('cleanup-comparison-v81'),
 w.includes('remediation-v81'),
 w.includes("version:'81.0.0'"),
 w.includes("v81:'signed-chain-verification-history-policy-alert-audit-chain-cleanup-comparison-history-retention-remediation'")
];
if(checks.some(x=>!x)) throw new Error('V81 regression failed');
console.log('V81 regression OK');
