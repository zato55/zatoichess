#!/usr/bin/env node
const base = (process.argv[2] || process.env.ZATO_BASE_URL || '').replace(/\/$/, '');
if (!base) {
  console.error('Kullanım: node scripts/smoke-test.mjs https://zato.example.com');
  process.exit(2);
}
const cookie = process.env.ZATO_COOKIE || '';
const results = [];
async function check(name, path, init = {}) {
  try {
    const r = await fetch(base + path, { ...init, headers: { ...(init.headers || {}), ...(cookie ? {cookie} : {}) } });
    let body = null; try { body = await r.json(); } catch {}
    const ok = r.ok && (body?.ready !== false) && (body?.ok !== false);
    results.push({name, ok, status:r.status, body});
    console.log(`${ok ? 'OK' : 'FAIL'} ${name} [${r.status}]`);
    return {r,body};
  } catch (e) { results.push({name,ok:false,error:String(e)}); console.log(`FAIL ${name} ${e}`); return null; }
}
await check('system status','/api/system/status');
if (!cookie) console.log('INFO authenticated smoke skipped: ZATO_COOKIE verilmedi.');
else await check('authenticated smoke','/api/system/smoke');
const failed = results.filter(x=>!x.ok);
console.log(`\nZATO smoke: ${results.length-failed.length}/${results.length} başarılı.`);
if (failed.length) process.exit(1);
