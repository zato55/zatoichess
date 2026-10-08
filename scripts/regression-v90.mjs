import fs from 'node:fs';
import path from 'node:path';
const root = path.resolve(new URL('..', import.meta.url).pathname);
const pkg = JSON.parse(fs.readFileSync(path.join(root,'package.json'),'utf8'));
if (pkg.version !== '90.0.0') throw new Error('version');
for (const p of [
 'docs/releases/V91_RELEASE_NOTES.md',
 'docs/releases/V91_PRODUCTION_CHECKLIST.md',
 'docs/continuation/RELEASE_CANDIDATE_V91.md',
 'docs/continuation/PRODUCTION_EVIDENCE_MANIFEST_V91.md',
 'scripts/release-gate-v91.mjs'
]) if (!fs.existsSync(path.join(root,p))) throw new Error(`missing:${p}`);
const ctx=fs.readFileSync(path.join(root,'docs/continuation/ZATO_PROJECT_CONTEXT.md'),'utf8');
if(!ctx.includes('V91') || !ctx.includes('1.0')) throw new Error('context');
const manifest=fs.readFileSync(path.join(root,'docs/continuation/PRODUCTION_EVIDENCE_MANIFEST_V91.md'),'utf8');
for(const token of ['CODE_READY','PRODUCTION_CONFIGURED','PRODUCTION_RUNTIME_VALIDATED','1.0_DECISION']) if(!manifest.includes(token)) throw new Error(`manifest:${token}`);
console.log('V91 regression OK');
