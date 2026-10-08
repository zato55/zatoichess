import fs from 'node:fs';
import path from 'node:path';
const root=process.cwd();
const must=[
 ['worker/index.ts',["version:'45.0.0'",'isTournamentTiebreak','!isTournamentTiebreak','standings','tiebreak_game_id','v45:\'standings-and-rating-neutral-tiebreaks\'']],
 ['db/migrations/V45.sql',['idx_tournament_matches_tournament_winner','idx_tournament_matches_players']],
 ['src/App.tsx',['tournament-standings','Standings','tournamentDetail.standings','Replay tie-break']],
 ['src/styles.css',['tournament-standings']],
 ['wrangler.toml',['*/5 * * * *']],
 ['ZATO_PROJECT_CONTEXT.md',['V45','NEXT CHAT']]
];
let failures=[];
for(const [file,needles] of must){const p=path.join(root,file);if(!fs.existsSync(p)){failures.push(`${file}: missing`);continue;}const s=fs.readFileSync(p,'utf8');for(const n of needles)if(!s.includes(n))failures.push(`${file}: missing marker ${n}`)}
const pkg=JSON.parse(fs.readFileSync(path.join(root,'package.json'),'utf8'));if(pkg.version!=='45.0.0')failures.push('package version mismatch');
const schema=fs.readFileSync(path.join(root,'db/schema.sql'),'utf8');for(const n of ['tournaments','tournament_matches','tiebreak_mode','tiebreak_game_id','tiebreak_room_code'])if(!schema.includes(n))failures.push(`schema missing ${n}`);
if(failures.length){console.error('V45 regression FAILED');for(const f of failures)console.error(' -',f);process.exit(1)}
console.log('V45 regression OK');
