import fs from 'node:fs';
import path from 'node:path';
const root=process.cwd();
const must=[
 ['worker/index.ts',["version:'45.0.0'",'tournamentAfterGame','tiebreak_mode','tiebreak_game_id','tiebreak_room_code','pending_replay','Tie-break maçı hazır','Bu turnuva maçında oyuncu değilsiniz','/api/tournaments/history']],
 ['db/migrations/V44.sql',['ALTER TABLE tournaments ADD COLUMN tiebreak_mode','ALTER TABLE tournament_matches ADD COLUMN tiebreak_game_id','ALTER TABLE tournament_matches ADD COLUMN tiebreak_room_code','idx_tournament_matches_tiebreak_game','idx_tournament_matches_tiebreak_room','idx_tournament_matches_tiebreak_room_unique']],
 ['src/App.tsx',['tournamentHistory','tournamentTiebreakMode','tiebreakMode:tournamentTiebreakMode','Replay tie-break','Tie-break’e gir']],
 ['src/styles.css',['tournament-create-controls','tournament-history','tiebreak-note']],
 ['wrangler.toml',['*/5 * * * *']],
 ['ZATO_PROJECT_CONTEXT.md',['V44','NEXT CHAT']]
];
let failures=[];
for(const [file,needles] of must){const p=path.join(root,file);if(!fs.existsSync(p)){failures.push(`${file}: missing`);continue;}const s=fs.readFileSync(p,'utf8');for(const n of needles)if(!s.includes(n))failures.push(`${file}: missing marker ${n}`)}
const pkg=JSON.parse(fs.readFileSync(path.join(root,'package.json'),'utf8'));if(pkg.version!=='45.0.0')failures.push('package version mismatch');
const schema=fs.readFileSync(path.join(root,'db/schema.sql'),'utf8');for(const n of ['tournaments','tournament_matches','tournament_rewards','tiebreak_mode','tiebreak_game_id','tiebreak_room_code'])if(!schema.includes(n))failures.push(`schema missing ${n}`);
if(failures.length){console.error('V44 regression FAILED');for(const f of failures)console.error(' -',f);process.exit(1)}
console.log('V44 regression OK');
