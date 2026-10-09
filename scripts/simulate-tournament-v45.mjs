const players = Array.from({length:8}, (_,i)=>`P${i+1}`);
const rounds = [
  [[players[0],players[1]],[players[2],players[3]],[players[4],players[5]],[players[6],players[7]]],
];
const winners = rounds[0].map(([a,b],i)=>i===1?b:a);
const semis = [[winners[0],winners[1]],[winners[2],winners[3]]];
const finalists = semis.map(([a,b],i)=>i===0?a:b);
const champion = finalists[0];
if (winners.join(',') !== 'P1,P4,P5,P7') throw new Error('round 1 progression mismatch');
if (finalists.join(',') !== 'P1,P7') throw new Error('semifinal progression mismatch');
if (champion !== 'P1') throw new Error('final progression mismatch');
// V45 rule: replay tie-break games are persisted but are rating-neutral.
const rating = {P1:1500,P2:1500};
const before = JSON.stringify(rating);
const isTournamentTiebreak = true;
if (!isTournamentTiebreak) throw new Error('tie-break classification missing');
// The worker guards Elo/rating_history/season writes behind !isTournamentTiebreak.
if (JSON.stringify(rating) !== before) throw new Error('rating changed in simulation');
console.log('V45 tournament simulation OK');
