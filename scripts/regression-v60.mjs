import fs from 'node:fs';
import path from 'node:path';
import {execFileSync} from 'node:child_process';
const root=process.cwd();
const pkg=JSON.parse(fs.readFileSync(path.join(root,'package.json'),'utf8'));
if(pkg.version!=='60.0.0') throw new Error('version');
const migration=fs.readFileSync(path.join(root,'db/migrations/V60.sql'),'utf8');
for(const needle of ['tournament_share_alert_ack','PRIMARY KEY(share_id, alert)','idx_tournament_share_alert_ack_share']) if(!migration.includes(needle)) throw new Error('migration:'+needle);
const worker=fs.readFileSync(path.join(root,'worker/index.ts'),'utf8');
for(const needle of ['shareExportIntegrity','runShareMaintenance','tournamentShareAlertAck','schemaVersion:\'1.0\'','exportVersion:\'v60\'','algorithm:\'SHA-256\'','cacheSummary','tournament_share_alert_ack','acknowledgedAt']) if(!worker.includes(needle)) throw new Error('worker:'+needle);
const app=fs.readFileSync(path.join(root,'src/App.tsx'),'utf8');
for(const needle of ['acknowledgeTournamentShareAlert','Cache route özeti','Uyarı geçmişi']) if(!app.includes(needle)) throw new Error('ui:'+needle);
const context=fs.readFileSync(path.join(root,'ZATO_PROJECT_CONTEXT.md'),'utf8');
if(!context.includes('V60')) throw new Error('context');
const py=`
import sqlite3, tempfile, pathlib, datetime
p=tempfile.NamedTemporaryFile(delete=False).name
c=sqlite3.connect(p)
s=pathlib.Path('db/migrations/V59.sql').read_text()+pathlib.Path('db/migrations/V60.sql').read_text()
c.executescript(s); c.executescript(pathlib.Path('db/migrations/V60.sql').read_text())
c.execute("INSERT INTO tournament_share_alert_ack VALUES(?,?,?,?)",('s1','rate-limit','2026-10-08T00:00:00Z','u1'))
c.execute("INSERT INTO tournament_share_cache_daily VALUES(?,?,?,?,?,?)",('2026-10-07','t1','s1','html',1,2))
c.execute("INSERT INTO tournament_share_cache_daily VALUES(?,?,?,?,?,?)",('2026-10-08','t1','s1','html',2,2))
c.execute("INSERT INTO tournament_share_alert_history VALUES(?,?,?,?,?,?,?)",('a1','t1','s1','rate-limit','2026-01-01','2026-10-08',2))
c.execute("INSERT INTO tournament_share_alert_history VALUES(?,?,?,?,?,?,?)",('a2','t1','s1','old','2025-01-01','2026-03-01',1))
cut=(datetime.datetime(2026,10,8)-datetime.timedelta(days=180)).isoformat()
c.execute("DELETE FROM tournament_share_alert_history WHERE last_seen_at < ?",(cut,))
assert c.execute("select count(*) from tournament_share_alert_ack").fetchone()[0]==1
assert c.execute("select count(*) from tournament_share_alert_history where alert='rate-limit'").fetchone()[0]==1
assert c.execute("select count(*) from tournament_share_alert_history where alert='old'").fetchone()[0]==0
assert c.execute("select sum(origin_hits),sum(conditional_hits) from tournament_share_cache_daily").fetchone()==(3,4)
print('V60 sqlite migration/idempotency + maintenance replay OK')
`;
execFileSync('python3',['-c',py],{cwd:root,stdio:'inherit'});
console.log('V60 regression OK');
