import fs from 'node:fs';
import path from 'node:path';
const root = process.cwd();
const read = f => fs.readFileSync(path.join(root, f), 'utf8');
const pkg = JSON.parse(read('package.json'));
const checks = [
  ['version', pkg.version === '88.0.0'],
  ['release gate script', pkg.scripts['release-gate:v88'] === 'node scripts/release-gate-v88.mjs'],
  ['regression script', pkg.scripts['regression:v88'] === 'node scripts/regression-v88.mjs'],
  ['D1 binding', /binding\s*=\s*"DB"/.test(read('wrangler.toml'))],
  ['cron', /crons\s*=\s*\["\*\/5 \* \* \* \*"\]/.test(read('wrangler.toml'))],
  ['deployment runbook', fs.existsSync(path.join(root,'docs/continuation/DEPLOYMENT_RUNBOOK.md'))],
  ['production evidence template', fs.existsSync(path.join(root,'docs/continuation/PRODUCTION_EVIDENCE_TEMPLATE.md'))],
  ['architecture', fs.existsSync(path.join(root,'docs/continuation/ARCHITECTURE.md'))],
  ['current state', fs.existsSync(path.join(root,'docs/continuation/CURRENT_STATE.md'))],
  ['next steps', fs.existsSync(path.join(root,'docs/continuation/NEXT_STEPS.md'))],
  ['release notes', fs.existsSync(path.join(root,'docs/releases/V88_RELEASE_NOTES.md'))],
  ['production checklist', fs.existsSync(path.join(root,'docs/releases/V88_PRODUCTION_CHECKLIST.md'))]
];
const failed = checks.filter(([, ok]) => !ok).map(([name]) => name);
if (failed.length) { console.error(`V88 regression FAILED: ${failed.join(', ')}`); process.exit(1); }
console.log('V88 regression OK');
