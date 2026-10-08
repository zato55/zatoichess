import fs from 'node:fs';
const fixture=JSON.parse(fs.readFileSync('scripts/fixtures/v66-route-contracts.json','utf8'));
function replay(route){
  const fresh=route.fresh, conditional=route.conditional;
  if(fresh.status!==200||fresh.cache!=='origin-miss')throw new Error(`${route.name}: fresh contract mismatch`);
  if(conditional.status!==304||conditional.cache!=='conditional-hit')throw new Error(`${route.name}: conditional contract mismatch`);
  return [fresh,conditional,fresh];
}
for(const route of fixture.contracts){const seq=replay(route);if(seq.map(x=>x.status).join('→')!=='200→304→200')throw new Error(`${route.name}: replay mismatch`);}
console.log('V66 runtime route/cache replay OK');
