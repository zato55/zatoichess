import fs from 'node:fs';
import path from 'node:path';
const root=process.cwd();
const must=[
 ['worker/index.ts',["version:'43.0.0'",'tournamentAfterGame','draw_seed_tiebreak','tournament_update','Turnuva maçı hazır','Turnuva şampiyonusun!','tie_break']],
 ['db/migrations/V43.sql',['ALTER TABLE tournament_matches ADD COLUMN tie_break','ALTER TABLE tournament_matches ADD COLUMN winner_reason','ALTER TABLE notification_preferences ADD COLUMN tournament_update']],
 ['src/App.tsx',['tournaments','spectateTournamentMatch','Seyirci Modu','tiebreak-note','tournament_update']],
 ['src/styles.css',['spectator-modal','spectator-banner','tiebreak-note']],
 ['wrangler.toml',['*/5 * * * *']],
 ['ZATO_PROJECT_CONTEXT.md',['V43','NEXT CHAT']]
];
let failures=[];
for(const [file,needles] of must){const p=path.join(root,file);if(!fs.existsSync(p)){failures.push(`${file}: missing`);continue;}const s=fs.readFileSync(p,'utf8');for(const n of needles)if(!s.includes(n))failures.push(`${file}: missing marker ${n}`)}
const pkg=JSON.parse(fs.readFileSync(path.join(root,'package.json'),'utf8'));if(pkg.version!=='43.0.0')failures.push('package version mismatch');
const schema=fs.readFileSync(path.join(root,'db/schema.sql'),'utf8');for(const n of ['tournaments','tournament_players','tournament_matches','tournament_rewards','tie_break','winner_reason','tournament_update'])if(!schema.includes(n))failures.push(`schema missing ${n}`);
if(failures.length){console.error('V43 regression FAILED');for(const f of failures)console.error(' -',f);process.exit(1)}
console.log('V43 regression OK');
