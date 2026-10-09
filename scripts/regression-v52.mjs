import fs from 'node:fs';
import path from 'node:path';
const root=path.resolve(new URL('..',import.meta.url).pathname);
const worker=fs.readFileSync(path.join(root,'worker','index.ts'),'utf8');
const migration=fs.readFileSync(path.join(root,'db','migrations','V52.sql'),'utf8');
const pkg=JSON.parse(fs.readFileSync(path.join(root,'package.json'),'utf8'));
const context=fs.readFileSync(path.join(root,'ZATO_PROJECT_CONTEXT.md'),'utf8');
const checks=[
  ['version',pkg.version==='52.0.0'],
  ['rate limiter',worker.includes('allowPublicShareRequest') && worker.includes('hits||0)>=60')],
  ['daily analytics',worker.includes('tournament_share_daily') && migration.includes('CREATE TABLE IF NOT EXISTS tournament_share_daily')],
  ['rate table',migration.includes('CREATE TABLE IF NOT EXISTS tournament_share_rate_limits')],
  ['no visitor identity storage',!migration.match(/ip|user.?agent|fingerprint/i)],
  ['replay ply state',worker.includes('searchParams.get(\'ply\')') && worker.includes('selectedPly')],
  ['V52 status',worker.includes("version:'52.0.0'") && worker.includes("v52:'public-share-rate-limiting-daily-privacy-safe-analytics-and-replay-state'")],
  ['context continuation',context.includes('V52') && context.includes('NEXT CHAT')]
];
const bad=checks.filter(([,ok])=>!ok);
if(bad.length){console.error('V52 regression FAILED'); for(const [n] of bad) console.error('-',n); process.exit(1);}
console.log('V52 regression OK');
