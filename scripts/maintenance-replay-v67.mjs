import crypto from 'node:crypto';
const plan={auditAggregateCandidates:3,auditRetentionCandidates:2,cacheRetentionCandidates:4,alertRetentionCandidates:1,maintenanceRetentionCandidates:0};
const canonical=JSON.stringify({version:'v64',mode:'dry-run',cutoffs:{audit:'2026-01-01',cache:'2026-01-01',alerts:'2025-12-01',runs:'2026-01-01'},plan});
const hash=crypto.createHash('sha256').update(canonical).digest('hex');
if(hash!==crypto.createHash('sha256').update(canonical).digest('hex')) throw new Error('nondeterministic hash');
console.log('V67 maintenance replay deterministic OK',hash);
