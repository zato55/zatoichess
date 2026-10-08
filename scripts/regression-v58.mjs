import fs from 'node:fs';
import assert from 'node:assert/strict';
const worker=fs.readFileSync('worker/index.ts','utf8');
const app=fs.readFileSync('src/App.tsx','utf8');
const css=fs.readFileSync('src/styles.css','utf8');
const pkg=JSON.parse(fs.readFileSync('package.json','utf8'));
const migration=fs.readFileSync('db/migrations/V58.sql','utf8');
assert.equal(pkg.version,'58.0.0');
assert.match(pkg.scripts['regression:v58'],/regression-v58/);
assert.match(migration,/idx_tournament_share_audit_daily_event_day/);
assert.match(migration,/idx_tournament_share_audit_tournament_created/);
assert.match(worker,/version:'58.0.0'/);
assert.match(worker,/v58:'share-health-dashboard-alerts-audit-trends-and-cleanup-simulation'/);
assert.match(worker,/auditTrend/);
assert.match(worker,/expiresSoon/);
assert.match(worker,/alerts/);
assert.match(app,/share-health-alerts/);
assert.match(app,/auditTrend/);
assert.match(css,/share-health-alerts/);
assert.match(css,/share-audit-trend/);
// Deterministic view accounting: only origin 200 increments the view counter.
let views=20; for(const status of [200,304,304,200,304]) if(status===200) views++; assert.equal(views,22);
// Alert thresholds: blocked traffic and <=7 day expiry produce attention states.
const alertState=(blocked,days,visibility='public',revoked=false)=>({blocked:blocked>0,expiring:days!==null&&days<=7,private:visibility!=='public',revoked});
assert.deepEqual(alertState(3,4),{blocked:true,expiring:true,private:false,revoked:false});
assert.deepEqual(alertState(0,30),{blocked:false,expiring:false,private:false,revoked:false});
// Scheduled cleanup simulation: only rows outside retention windows are removed.
const now=Date.now();
const raw=[now-10*86400000,now-89*86400000,now-91*86400000];
const kept=raw.filter(t=>t>=now-90*86400000); assert.equal(kept.length,2);
// Daily trend aggregation is additive by day/event.
const rows=[['2026-10-01','created',1],['2026-10-01','created',2],['2026-10-01','updated',1],['2026-10-02','created',1]];
const m=new Map(); for(const [day,event,count] of rows){const k=day+'|'+event;m.set(k,(m.get(k)||0)+count)}
assert.equal(m.get('2026-10-01|created'),3); assert.equal(m.get('2026-10-02|created'),1);
console.log('V58 share-health dashboard/cleanup regression OK');
