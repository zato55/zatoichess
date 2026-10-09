import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const pkg = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'));
const required = [
  'docs/releases/V89_RELEASE_NOTES.md',
  'docs/releases/V89_PRODUCTION_CHECKLIST.md',
  'docs/continuation/ZATO_PROJECT_CONTEXT.md',
  'docs/continuation/ARCHITECTURE.md',
  'docs/continuation/CURRENT_STATE.md',
  'docs/continuation/NEXT_STEPS.md',
  'docs/continuation/DEPLOYMENT_RUNBOOK.md',
  'docs/continuation/PRODUCTION_EVIDENCE_TEMPLATE.md',
  'docs/continuation/RELEASE_CANDIDATE_V89.md',
  'scripts/regression-v89.mjs',
  'scripts/release-candidate-v89.mjs'
];
for (const file of required) {
  if (!fs.existsSync(path.join(root, file))) throw new Error(`missing:${file}`);
}
if (pkg.version !== '89.0.0') throw new Error(`version:${pkg.version}`);
if (!pkg.scripts?.['release-candidate:v89']) throw new Error('missing-release-candidate-script');
const context = fs.readFileSync(path.join(root, 'docs/continuation/ZATO_PROJECT_CONTEXT.md'), 'utf8');
if (!context.includes('V89') || !context.includes('1.0')) throw new Error('continuation-context-not-updated');
const candidate = fs.readFileSync(path.join(root, 'docs/continuation/RELEASE_CANDIDATE_V89.md'), 'utf8');
if (!candidate.includes('PRODUCTION_RUNTIME_VALIDATED: PENDING')) throw new Error('production-pending-marker-missing');
if (!candidate.includes('CODE_READY: PASS')) throw new Error('code-ready-marker-missing');
console.log('V89 regression OK');
