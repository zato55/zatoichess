import fs from 'node:fs';
import path from 'node:path';
const root=process.cwd();
const must=[
 ['worker/index.ts',["version:'46.0.0'", "v46:'tournament-analytics-profile-and-history'",'tournamentStats','tournamentHistory']],
 ['db/migrations/V46.sql',['idx_tournament_players_user','idx_tournament_matches_winner','idx_tournament_matches_players']],
 ['src/App.tsx',['tournament-profile','tournament-analytics','playerProfile.tournamentStats','h.tieBreaks']],
 ['src/styles.css',['tournament-analytics','tournament-profile']],
 ['ZATO_PROJECT_CONTEXT.md',['V46','NEXT CHAT']]
];
let failures=[];
for(const [file,needles] of must){const p=path.join(root,file);if(!fs.existsSync(p)){failures.push(`${file}: missing`);continue;}const s=fs.readFileSync(p,'utf8');for(const n of needles)if(!s.includes(n))failures.push(`${file}: missing marker ${n}`)}
const pkg=JSON.parse(fs.readFileSync(path.join(root,'package.json'),'utf8'));if(pkg.version!=='46.0.0')failures.push('package version mismatch');
const schema=fs.readFileSync(path.join(root,'db/schema.sql'),'utf8');for(const n of ['tournaments','tournament_players','tournament_matches','tournament_rewards'])if(!schema.includes(n))failures.push(`schema missing ${n}`);
if(failures.length){console.error('V46 regression FAILED');for(const f of failures)console.error(' -',f);process.exit(1)}
console.log('V46 regression OK');
