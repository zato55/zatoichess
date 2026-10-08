import fs from 'node:fs'; import path from 'node:path';
const root=process.cwd();
const pkg=JSON.parse(fs.readFileSync(path.join(root,'package.json'),'utf8'));
if(pkg.version!=='91.0.0') throw new Error('V91 version mismatch');
for(const f of ['docs/releases/V91_RELEASE_NOTES.md','docs/releases/V91_PRODUCTION_CHECKLIST.md','docs/continuation/ZATO_PROJECT_CONTEXT.md','docs/continuation/CURRENT_STATE.md','docs/continuation/NEXT_STEPS.md']) if(!fs.existsSync(path.join(root,f))) throw new Error('missing '+f);
console.log('V91 regression OK');
