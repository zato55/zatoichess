import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const pkg = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'));
if (pkg.version !== '92.0.0') throw new Error(`version=${pkg.version}`);
for (const file of [
  'docs/releases/V92_RELEASE_NOTES.md',
  'docs/releases/V92_PRODUCTION_CHECKLIST.md',
  'docs/continuation/PRODUCTION_HANDOFF_V92.md',
  'docs/continuation/ZATO_PROJECT_CONTEXT.md',
  'docs/continuation/CURRENT_STATE.md',
  'docs/continuation/NEXT_STEPS.md',
  'scripts/regression-v92.mjs'
]) {
  if (!fs.existsSync(path.join(root, file))) throw new Error(`missing ${file}`);
}
const checklist = fs.readFileSync(path.join(root, 'docs/releases/V92_PRODUCTION_CHECKLIST.md'), 'utf8');
if (!checklist.includes('1.0 = BLOCKED')) throw new Error('release gate missing');
const handoff = fs.readFileSync(path.join(root, 'docs/continuation/PRODUCTION_HANDOFF_V92.md'), 'utf8');
if (!handoff.includes('Gizli değerler ZIP\'e veya kaynak koda yazılmaz')) throw new Error('secret handling missing');
console.log('V92 regression OK');
