import fs from 'node:fs';
import path from 'node:path';
import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';

const root=path.resolve(new URL('.',import.meta.url).pathname,'..');
const worker=fs.readFileSync(path.join(root,'worker/index.ts'),'utf8');
const app=fs.readFileSync(path.join(root,'src/App.tsx'),'utf8');
const migration=fs.readFileSync(path.join(root,'db/migrations/V50.sql'),'utf8');
const pkg=JSON.parse(fs.readFileSync(path.join(root,'package.json'),'utf8'));
assert.equal(pkg.version,'50.0.0');
assert.match(worker,/views_count/);
assert.match(worker,/last_viewed_at/);
assert.ok(worker.includes('share\\/stats'));
assert.match(worker,/og\.svg/);
assert.match(worker,/og:image/);
assert.match(worker,/zato-board/);
assert.match(worker,/tournament_shares/);
assert.match(app,/loadTournamentShareStats/);
assert.match(app,/Public link/);
assert.match(migration,/ADD COLUMN views_count INTEGER NOT NULL DEFAULT 0/);
assert.match(migration,/ADD COLUMN last_viewed_at TEXT/);
assert.match(migration,/idx_tournament_shares_views/);
assert.doesNotMatch(worker,/SELECT \* FROM users[^;]*public/);
const forbidden=['roomCode','session_id','password_hash'];
for(const token of forbidden){
  const publicStart=worker.indexOf("const publicShareMatch");
  const publicEnd=worker.indexOf("const publicSharePage");
  const slice=worker.slice(publicStart,publicEnd);
  assert.doesNotMatch(slice,new RegExp(token));
}
const tmp=path.join(root,'.v50-schema-test.sqlite');
try{
  execFileSync('python3',['-c',`import sqlite3; db=sqlite3.connect(r'''${tmp}'''); db.executescript('CREATE TABLE tournament_shares (id TEXT PRIMARY KEY,tournament_id TEXT NOT NULL,token_hash TEXT NOT NULL,created_by TEXT NOT NULL,created_at TEXT,revoked_at TEXT);'); db.executescript(open(r'''${path.join(root,'db/migrations/V50.sql')}''').read()); print('schema-ok')`],{encoding:'utf8'});
}catch(e){
  const msg=String(e?.stderr||e?.message||e); throw e;
}
fs.rmSync(tmp,{force:true});
console.log('V50 regression OK');
