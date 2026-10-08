import fs from 'node:fs';
const worker=fs.readFileSync('worker/index.ts','utf8');
const pkg=JSON.parse(fs.readFileSync('package.json','utf8'));
const mig=fs.readFileSync('db/migrations/V80.sql','utf8');
const checks=[
  ['version',pkg.version==='80.0.0'],
  ['script',Boolean(pkg.scripts['regression:v80'])],
  ['chain export route',worker.includes('chain-export-v80')],
  ['chain verify route',worker.includes('chain-verify-v80')],
  ['alert audit route',worker.includes('policy-drift-alert-audit-v80')],
  ['cleanup compare route',worker.includes('cleanup-replay-v80')],
  ['policy consistency route',worker.includes('policy-consistency-v80')],
  ['chain export table',mig.includes('tournament_share_verification_chain_exports')],
  ['chain checks table',mig.includes('tournament_share_verification_chain_checks')],
  ['cleanup comparison table',mig.includes('tournament_share_cleanup_replay_comparisons')],
  ['policy consistency table',mig.includes('tournament_share_retention_policy_consistency')],
  ['readiness v80',worker.includes("version:'80.0.0'") && worker.includes("v80:'verification-chain-export-policy-alert-audit-chain-cleanup-comparison-retention-hardening'")]
];
const bad=checks.filter(([,ok])=>!ok); if(bad.length){console.error('V80 regression FAILED',bad);process.exit(1)} console.log('V80 regression OK');
