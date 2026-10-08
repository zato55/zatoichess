import fs from 'node:fs';
import path from 'node:path';
const root=process.cwd();
const must=[
 ['worker/index.ts',["version:'47.0.0'","v47:'tournament-round-analytics-and-entry-rating'",'rating_at_entry','tieBreakHistory','averageOpponentRating']],
 ['db/migrations/V47.sql',['rating_at_entry','idx_tournament_players_rating','idx_tournament_matches_round_status','idx_tournament_matches_replay_games']],
 ['src/App.tsx',['tournament-rounds','match-ratings','Replay incele','Ort. rakip']],
 ['src/styles.css',['tournament-rounds','match-ratings']],
 ['ZATO_PROJECT_CONTEXT.md',['V47','NEXT CHAT']]
];
const failures=[];
for(const [file,needles] of must){const p=path.join(root,file);if(!fs.existsSync(p)){failures.push(`${file}: missing`);continue;}const s=fs.readFileSync(p,'utf8');for(const n of needles)if(!s.includes(n))failures.push(`${file}: missing marker ${n}`)}
const pkg=JSON.parse(fs.readFileSync(path.join(root,'package.json'),'utf8'));if(pkg.version!=='47.0.0')failures.push('package version mismatch');
const schema=fs.readFileSync(path.join(root,'db/schema.sql'),'utf8');if(!schema.includes('rating_at_entry'))failures.push('schema missing rating_at_entry');
if(failures.length){console.error('V47 regression FAILED');for(const f of failures)console.error(' -',f);process.exit(1)}
console.log('V47 regression OK');
