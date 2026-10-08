import fs from 'node:fs';
import path from 'node:path';
const root=process.cwd();
const must=[
 ['worker/index.ts', ['version:\'41.0.0\'','function cupWindow','function arenaJoinAllowed','/api/cup','arena_join_log','cup_rewards','finalizeCupRewards']],
 ['db/migrations/V41.sql',['cup_events','cup_participants','cup_rewards','arena_join_log']],
 ['src/App.tsx',['cupDaily','cupWeekly','joinCup','Günlük Cup','Haftalık Cup']],
 ['wrangler.toml',['*/5 * * * *']],
 ['ZATO_PROJECT_CONTEXT.md',['V41','NEXT CHAT']]
];
let failures=[];
for(const [file,needles] of must){const p=path.join(root,file);if(!fs.existsSync(p)){failures.push(`${file}: missing`);continue;}const s=fs.readFileSync(p,'utf8');for(const n of needles)if(!s.includes(n))failures.push(`${file}: missing marker ${n}`)}
const pkg=JSON.parse(fs.readFileSync(path.join(root,'package.json'),'utf8'));if(pkg.version!=='41.0.0')failures.push('package version mismatch');
if(failures.length){console.error('V41 regression FAILED');for(const f of failures)console.error(' -',f);process.exit(1)}
console.log('V41 regression OK');
