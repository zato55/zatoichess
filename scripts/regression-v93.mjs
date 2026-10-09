import fs from 'node:fs';
import path from 'node:path';
const root=process.cwd(), mig=path.join(root,'db','migrations');
const files=fs.readdirSync(mig).filter(x=>x.endsWith('.sql')).sort((a,b)=>a.localeCompare(b,undefined,{numeric:true}));
if(!files.includes('V84.sql')||!files.includes('V85.sql')) throw new Error('V84/V85 migration eksik');
if(files.length<50) throw new Error(`Migration sayısı beklenenden az: ${files.length}`);
if(fs.existsSync(path.join(root,'db','migrations_V41.tmp'))) throw new Error('Geçici migration dosyası mevcut');
console.log(`V93 migration package regression OK (${files.length} SQL files)`);
