from pathlib import Path
p=Path('/mnt/data/v53work/worker/index.ts')
s=p.read_text()
s=s.replace("function json(data:unknown, init:ResponseInit={}) {\n  return new Response(JSON.stringify(data), { ...init, headers:{'content-type':'application/json; charset=utf-8', ...(init.headers||{})} });\n}", """function json(data:unknown, init:ResponseInit={}) {\n  return new Response(JSON.stringify(data), { ...init, headers:{'content-type':'application/json; charset=utf-8', ...(init.headers||{})} });\n}\nasync function cachedJson(request:Request,data:unknown,maxAge=60){\n  const body=JSON.stringify(data);\n  const etag='\\\"'+await sha256Hex(body)+'\\\"';\n  if(request.headers.get('if-none-match')===etag) return new Response(null,{status:304,headers:{etag,'cache-control':`public, max-age=${maxAge}`}});\n  return new Response(body,{status:200,headers:{'content-type':'application/json; charset=utf-8',etag,'cache-control':`public, max-age=${maxAge}, must-revalidate`}});\n}""")
old="return json({share:{title:`${t.name} · ZATO Chess`,status:t.status,players:players.length,maxPlayers:t.max_players,champion,views:Number(share.views_count||0)+1},tournament:t,players,matches,rewards,completedMatches:completed});"
new="return cachedJson(request,{share:{title:`${t.name} · ZATO Chess`,status:t.status,players:players.length,maxPlayers:t.max_players,champion,views:Number(share.views_count||0)+1},tournament:t,players,matches,rewards,completedMatches:completed},60);"
s=s.replace(old,new)
old2="return json({match,game,moves,selectedPly:Number.isFinite(requestedPly)?requestedPly:moves.length});"
new2="return cachedJson(request,{match,game,moves,selectedPly:Number.isFinite(requestedPly)?requestedPly:moves.length},300);"
s=s.replace(old2,new2)
s=s.replace("return new Response(svg,{headers:{'content-type':'image/svg+xml; charset=utf-8','cache-control':'public, max-age=300'}});", "const svgEtag='\\\"'+await sha256Hex(svg)+'\\\"'; if(request.headers.get('if-none-match')===svgEtag)return new Response(null,{status:304,headers:{etag:svgEtag,'cache-control':'public, max-age=300'}}); return new Response(svg,{headers:{'content-type':'image/svg+xml; charset=utf-8','cache-control':'public, max-age=300, must-revalidate',etag:svgEtag}});")
s=s.replace("version:'52.0.0',checkedAt:new Date().toISOString(),checks", "version:'53.0.0',checkedAt:new Date().toISOString(),checks")
s=s.replace("version:'52.0.0',checkedAt:new Date().toISOString(),activeArenas", "version:'53.0.0',checkedAt:new Date().toISOString(),activeArenas")
s=s.replace("version:'52.0.0',database", "version:'53.0.0',database")
s=s.replace("v52:'public-share-rate-limiting-daily-privacy-safe-analytics-and-replay-state'", "v52:'public-share-rate-limiting-daily-privacy-safe-analytics-and-replay-state',v53:'public-share-cache-etag-analytics-and-replay-controls'")
p.write_text(s)
