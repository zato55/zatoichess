import fs from 'node:fs'; import path from 'node:path';
const root=process.cwd(); const read=p=>fs.readFileSync(path.join(root,p),'utf8');
const pkg=JSON.parse(read('package.json')); if(pkg.version!=='85.0.0') throw new Error('version 85 bekleniyor');
const mig=read('db/migrations/V85.sql'); for(const t of ['tournament_share_v85_production_readiness','tournament_share_v85_readiness_history','tournament_share_v85_release_gates']) if(!mig.includes(`CREATE TABLE IF NOT EXISTS ${t}`)) throw new Error(`V85 tablo eksik: ${t}`);
const worker=read('worker/index.ts'); for(const x of ['runV85ProductionReadiness','production-readiness-v85','tournament_share_v85_production_readiness','v85:']) if(!worker.includes(x)) throw new Error(`V85 worker eksik: ${x}`); if(!worker.includes("version:'85.0.0'")) throw new Error('V85 readiness version eksik');
for(const f of ['docs/releases/V85_RELEASE_NOTES.md','docs/releases/V85_PRODUCTION_CHECKLIST.md','docs/continuation/ZATO_PROJECT_CONTEXT.md','docs/continuation/ARCHITECTURE.md','docs/continuation/CURRENT_STATE.md','docs/continuation/NEXT_STEPS.md']) if(!fs.existsSync(path.join(root,f))) throw new Error(`devir dokümanı eksik: ${f}`);
console.log('V85 regression OK');
