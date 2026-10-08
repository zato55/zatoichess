import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { spawnSync } from 'node:child_process';

const root = process.cwd();
const run = (cmd, args) => {
  const r = spawnSync(cmd, args, { cwd: root, encoding: 'utf8' });
  process.stdout.write(r.stdout || '');
  process.stderr.write(r.stderr || '');
  if (r.status !== 0) throw new Error(`${cmd} ${args.join(' ')} failed:${r.status}`);
};
run(process.execPath, ['scripts/regression-v89.mjs']);
const baseline = [
  ['wrangler D1 binding', /binding\s*=\s*\"DB\"/.test(fs.readFileSync(path.join(root, 'wrangler.toml'), 'utf8'))],
  ['rooms DO', /name\s*=\s*\"ROOMS\"/.test(fs.readFileSync(path.join(root, 'wrangler.toml'), 'utf8'))],
  ['social DO', /name\s*=\s*\"SOCIAL\"/.test(fs.readFileSync(path.join(root, 'wrangler.toml'), 'utf8'))],
  ['matchmaking DO', /name\s*=\s*\"MATCHMAKING\"/.test(fs.readFileSync(path.join(root, 'wrangler.toml'), 'utf8'))],
  ['cron', /crons\s*=\s*\[\"\*\/5 \* \* \* \*\"\]/.test(fs.readFileSync(path.join(root, 'wrangler.toml'), 'utf8'))],
  ['deployment runbook', fs.existsSync(path.join(root, 'docs/continuation/DEPLOYMENT_RUNBOOK.md'))],
  ['production evidence template', fs.existsSync(path.join(root, 'docs/continuation/PRODUCTION_EVIDENCE_TEMPLATE.md'))]
];
const failed = baseline.filter(([, ok]) => !ok).map(([name]) => name);
if (failed.length) throw new Error(`baseline checks failed:${failed.join(',')}`);
const pkg = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'));
const files = [
  'package.json', 'worker/index.ts', 'src/App.tsx', 'src/styles.css',
  'db/schema.sql', 'docs/continuation/ZATO_PROJECT_CONTEXT.md',
  'docs/continuation/CURRENT_STATE.md', 'docs/continuation/NEXT_STEPS.md',
  'docs/continuation/RELEASE_CANDIDATE_V89.md'
];
const hashes = {};
for (const rel of files) {
  const file = path.join(root, rel);
  if (!fs.existsSync(file)) throw new Error(`missing:${rel}`);
  hashes[rel] = crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex');
}
console.log(`V89 release candidate: ${pkg.version}`);
console.log('CODE_READY: PASS');
console.log('PRODUCTION_CONFIGURED: PENDING');
console.log('PRODUCTION_RUNTIME_VALIDATED: PENDING');
console.log('1.0_DECISION: BLOCKED_UNTIL_PRODUCTION_EVIDENCE');
console.log('SOURCE_HASHES:');
for (const [file, hash] of Object.entries(hashes)) console.log(`${hash}  ${file}`);
