import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const read = file => fs.readFileSync(path.join(root, file), 'utf8');
const exists = file => fs.existsSync(path.join(root, file));

const required = [
  'README.md', 'package.json', 'wrangler.toml', 'db/schema.sql',
  'worker/index.ts', 'src/App.tsx', 'src/styles.css',
  'scripts/regression-v88.mjs', 'scripts/release-gate-v88.mjs',
  'docs/continuation/ZATO_PROJECT_CONTEXT.md',
  'docs/continuation/ARCHITECTURE.md',
  'docs/continuation/CURRENT_STATE.md',
  'docs/continuation/NEXT_STEPS.md',
  'docs/continuation/DEPLOYMENT_RUNBOOK.md',
  'docs/continuation/PRODUCTION_EVIDENCE_TEMPLATE.md',
  'docs/releases/V88_RELEASE_NOTES.md',
  'docs/releases/V88_PRODUCTION_CHECKLIST.md'
];

const missing = required.filter(file => !exists(file));
if (missing.length) {
  console.error(`V88 release gate FAILED: eksik dosyalar: ${missing.join(', ')}`);
  process.exit(1);
}

const pkg = JSON.parse(read('package.json'));
if (pkg.version !== '88.0.0') throw new Error(`package version beklenmeyen değer: ${pkg.version}`);
if (pkg.scripts['regression:v88'] !== 'node scripts/regression-v88.mjs') throw new Error('V88 regression script tanımı hatalı.');
if (pkg.scripts['release-gate:v88'] !== 'node scripts/release-gate-v88.mjs') throw new Error('V88 release gate script tanımı hatalı.');

const wrangler = read('wrangler.toml');
const checks = [
  ['D1 binding', /binding\s*=\s*"DB"/.test(wrangler)],
  ['Durable Object ROOMS', /name\s*=\s*"ROOMS"/.test(wrangler)],
  ['Durable Object SOCIAL', /name\s*=\s*"SOCIAL"/.test(wrangler)],
  ['Durable Object MATCHMAKING', /name\s*=\s*"MATCHMAKING"/.test(wrangler)],
  ['5 dakikalık zamanlayıcı', /crons\s*=\s*\["\*\/5 \* \* \* \*"\]/.test(wrangler)],
  ['D1 placeholder tespit mekanizması', wrangler.includes('REPLACE_WITH_D1_DATABASE_ID')],
  ['gizli anahtarların dokümana yazılmaması', !/SHARE_EXPORT_SIGNING_SECRET\s*=\s*[^`\n]+/.test(read('docs/continuation/DEPLOYMENT_RUNBOOK.md'))]
];
const failed = checks.filter(([, ok]) => !ok).map(([name]) => name);
if (failed.length) {
  console.error(`V88 release gate FAILED: ${failed.join(', ')}`);
  process.exit(1);
}

const context = read('docs/continuation/ZATO_PROJECT_CONTEXT.md');
const current = read('docs/continuation/CURRENT_STATE.md');
const next = read('docs/continuation/NEXT_STEPS.md');
for (const [name, text, marker] of [
  ['devir bağlamı', context, 'V88'],
  ['mevcut durum', current, 'V88'],
  ['sonraki adımlar', next, '1.0']
]) {
  if (!text.includes(marker)) throw new Error(`${name} V88 geçişini içermiyor: ${marker}`);
}

console.log('V88 release gate OK');
console.log('CODE_READY: PASS');
console.log('PRODUCTION_CONFIGURED: PENDING (gerçek Cloudflare bilgileri gerekli)');
console.log('PRODUCTION_RUNTIME_VALIDATED: PENDING (gerçek Worker/D1/tarayıcı testi gerekli)');
console.log('1.0_DECISION: BLOCKED_UNTIL_PRODUCTION_EVIDENCE');
