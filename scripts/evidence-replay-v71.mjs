const fixture={
  left:[
    {route:'html',statusCode:200,cacheMarker:'origin-miss'},
    {route:'tournament-json',statusCode:304,cacheMarker:'conditional-hit'},
    {route:'replay-json',statusCode:200,cacheMarker:'origin-miss'}
  ],
  right:[
    {route:'html',statusCode:304,cacheMarker:'conditional-hit'},
    {route:'tournament-json',statusCode:304,cacheMarker:'conditional-hit'},
    {route:'replay-json',statusCode:200,cacheMarker:'origin-miss'}
  ]
};
function matrix(rows){const m=new Map();for(const r of rows){const x=m.get(r.route)||{route:r.route,total:0,passed:0,originHits:0,conditionalHits:0};x.total++;x.passed+=r.statusCode>=200&&r.statusCode<400?1:0;x.originHits+=r.statusCode===200?1:0;x.conditionalHits+=r.statusCode===304?1:0;m.set(r.route,x)}return [...m.values()];}
const a=matrix(fixture.left),b=matrix(fixture.right);
const compare=[...new Set([...a.map(x=>x.route),...b.map(x=>x.route)])].sort().map(route=>{const l=a.find(x=>x.route===route)||{},r=b.find(x=>x.route===route)||{};return {route,delta:{total:(r.total||0)-(l.total||0),passed:(r.passed||0)-(l.passed||0),originHits:(r.originHits||0)-(l.originHits||0),conditionalHits:(r.conditionalHits||0)-(l.conditionalHits||0)}}});
const expected=JSON.stringify([{route:'html',delta:{total:0,passed:0,originHits:-1,conditionalHits:1}},{route:'replay-json',delta:{total:0,passed:0,originHits:0,conditionalHits:0}},{route:'tournament-json',delta:{total:0,passed:0,originHits:0,conditionalHits:0}}]);
if(JSON.stringify(compare)!==expected)throw new Error('deterministic replay mismatch');
console.log('V71 deterministic evidence replay OK');
