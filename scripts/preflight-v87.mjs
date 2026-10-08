import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const required = [
  'README.md', 'package.json', 'wrangler.toml', 'db/schema.sql',
  'worker/index.ts', 'src/App.tsx', 'src/styles.css',
  'docs/continuation/ZATO_PROJECT_CONTEXT.md',
  'docs/continuation/ARCHITECTURE.md',
  'docs/continuation/CURRENT_STATE.md',
  'docs/continuation/NEXT_STEPS.md',
  'docs/releases/V87_RELEASE_NOTES.md',
  'docs/releases/V87_PRODUCTION_CHECKLIST.md'
];
const missing = required.filter(x => !fs.existsSync(path.join(root, x)));
if (missing.length) { console.error(`V87 preflight missing: ${missing.join(', ')}`); process.exit(1); }
const wrangler = fs.readFileSync(path.join(root,'wrangler.toml'),'utf8');
const warnings = [];
if (wrangler.includes('REPLACE_WITH_D1_DATABASE_ID')) warnings.push('D1 database_id henüz gerçek değerle değiştirilmemiş.');
if (!/crons\s*=\s*\["\*\/5 \* \* \* \*"\]/.test(wrangler)) warnings.push('Beklenen 5 dakikalık bakım zamanlayıcısı bulunamadı.');
const pkg = JSON.parse(fs.readFileSync(path.join(root,'package.json'),'utf8'));
if (pkg.version !== '87.0.0') throw new Error(`package version beklenmeyen değer: ${pkg.version}`);
const ctx = fs.readFileSync(path.join(root,'docs/continuation/ZATO_PROJECT_CONTEXT.md'),'utf8');
if (!ctx.includes('V87')) throw new Error('Devir bağlamı V87 olarak güncellenmemiş.');
console.log('V87 preflight OK');
for (const warning of warnings) console.log(`WARN: ${warning}`);
