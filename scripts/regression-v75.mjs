import fs from 'node:fs';
const worker=fs.readFileSync(new URL('../worker/index.ts',import.meta.url),'utf8');
const pkg=JSON.parse(fs.readFileSync(new URL('../package.json',import.meta.url),'utf8'));
const migration=fs.readFileSync(new URL('../db/migrations/V75.sql',import.meta.url),'utf8');
const context=fs.readFileSync(new URL('../docs/continuation/ZATO_PROJECT_CONTEXT.md',import.meta.url),'utf8');
for(const x of ['75.0.0','verification-history','verify-integrity','cleanup-replay','policy-check']) if(!(worker.includes(x)||context.includes(x)||pkg.version===x)) throw new Error('missing '+x);
for(const x of ['tournament_share_replay_bundle_verifications','tournament_share_cleanup_replay_history','tournament_share_retention_policy_checks']) if(!migration.includes(x)) throw new Error('migration '+x);
for(const x of ['signatureValid','integrityValid','policy_version','integrity_sha256']) if(!worker.includes(x)) throw new Error('worker '+x);
console.log('V75 regression OK');
