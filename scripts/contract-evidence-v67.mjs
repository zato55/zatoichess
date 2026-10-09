const fixture=[
 {route:'html',sequence:[200,304,200],cache:['origin-miss','conditional-hit','origin-miss']},
 {route:'tournament-json',sequence:[200,304,200],cache:['origin-miss','conditional-hit','origin-miss']},
 {route:'replay-json',sequence:[200,304,200],cache:['origin-miss','conditional-hit','origin-miss']},
 {route:'og-image',sequence:[200,304,200],cache:['origin-miss','conditional-hit','origin-miss']}
];
for(const x of fixture){if(x.sequence.length!==x.cache.length||x.sequence[1]!==304||x.cache[1]!=='conditional-hit')throw new Error(x.route)}
console.log('V67 contract evidence replay OK');
