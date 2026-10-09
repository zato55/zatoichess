const fs = require('fs');
const path = require('path');
const filePath = path.join(__dirname, 'worker', 'index.ts');

console.log('Reading', filePath);
let content = fs.readFileSync(filePath, 'utf8');

const fetchEndMarker = "return new Response('ZATO Chess Worker',{headers:{'content-type':'text/plain; charset=utf-8'}});";
const orphanMarker = "const tournamentShareV82RemediationExport=url.pathname.match";

const fetchEndIdx = content.indexOf(fetchEndMarker);
const orphanIdx = content.indexOf(orphanMarker);

console.log('fetch end marker at:', fetchEndIdx);
console.log('orphan marker at:', orphanIdx);

if (fetchEndIdx === -1) {
  console.error('HATA: fetch end marker bulunamadı. Dosya bozulmuş olabilir.');
  process.exit(1);
}
if (orphanIdx === -1) {
  console.log('Orphan block zaten yok. Dosya düzgün.');
  process.exit(0);
}
if (orphanIdx < fetchEndIdx) {
  console.log('Orphan block zaten fetch içinde görünüyor.');
  process.exit(0);
}

// Extract orphan block (from orphanIdx to end of file)
let orphanBlock = content.slice(orphanIdx).trimEnd();
// Remove from original location
let beforeOrphan = content.slice(0, orphanIdx).trimEnd();

// Insert before the fetch end marker
let fixed = beforeOrphan.replace(
  fetchEndMarker,
  orphanBlock + '\n    ' + fetchEndMarker
);

// Backup original
fs.writeFileSync(filePath + '.before-fix', content, 'utf8');
fs.writeFileSync(filePath, fixed, 'utf8');

console.log('✅ Onarım tamamlandı! Yedek: worker/index.ts.before-fix');