import fs from 'node:fs';
import path from 'node:path';
const root=process.cwd();
const must=[
 ['worker/index.ts',["version:'42.0.0'",'/api/tournaments','tournamentAfterGame','x-zato-spectator','room:spectator',"tournament_matches SET status='live'"]],
 ['db/migrations/V42.sql',['CREATE TABLE IF NOT EXISTS tournaments','CREATE TABLE IF NOT EXISTS tournament_players','CREATE TABLE IF NOT EXISTS tournament_matches','CREATE TABLE IF NOT EXISTS tournament_rewards']],
 ['src/App.tsx',['tournaments','createTournament','spectateTournamentMatch','Turnuvalar','room:spectator']],
 ['wrangler.toml',['*/5 * * * *']],
 ['ZATO_PROJECT_CONTEXT.md',['V42','NEXT CHAT']]
];
let failures=[];
for(const [file,needles] of must){const p=path.join(root,file);if(!fs.existsSync(p)){failures.push(`${file}: missing`);continue;}const s=fs.readFileSync(p,'utf8');for(const n of needles)if(!s.includes(n))failures.push(`${file}: missing marker ${n}`)}
const pkg=JSON.parse(fs.readFileSync(path.join(root,'package.json'),'utf8'));if(pkg.version!=='42.0.0')failures.push('package version mismatch');
const schema=fs.readFileSync(path.join(root,'db/schema.sql'),'utf8');for(const t of ['tournaments','tournament_players','tournament_matches','tournament_rewards'])if(!schema.includes(`CREATE TABLE IF NOT EXISTS ${t}`))failures.push(`schema missing ${t}`);
if(failures.length){console.error('V42 regression FAILED');for(const f of failures)console.error(' -',f);process.exit(1)}
console.log('V42 regression OK');
