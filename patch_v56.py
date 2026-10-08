from pathlib import Path
import json,re
root=Path('/mnt/data/v56work')
p=root/'worker/index.ts'
s=p.read_text()
# helpers
needle="function html(body:string,status=200){return new Response(`<!doctype html><html lang=\"tr\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"><meta name=\"theme-color\" content=\"#090b10\">${body}</body></html>`,{status,headers:{'content-type':'text/html; charset=utf-8','cache-control':'public, max-age=60'}});}\n"
repl=needle+"async function cachedHtml(request:Request,body:string,maxAge=60,etagSource:any=body){const etag='\"'+await sha256Hex(typeof etagSource==='string'?etagSource:JSON.stringify(etagSource))+'\"';const headers={\"content-type\":\"text/html; charset=utf-8\",etag,\"cache-control\":`public, max-age=${maxAge}, must-revalidate`};if(request.headers.get('if-none-match')===etag)return new Response(null,{status:304,headers:{...headers,\"x-zato-cache\":\"conditional-hit\"}});return new Response(body,{status:200,headers:{...headers,\"x-zato-cache\":\"origin-miss\"}});}\nasync function logShareAudit(db:any,tournamentId:string,shareId:string,event:string,metadata:any={}){await db.prepare(`INSERT INTO tournament_share_audit(id,tournament_id,share_id,event,metadata,created_at) VALUES(?,?,?,?,?,?)`).bind(crypto.randomUUID(),tournamentId,shareId,event,JSON.stringify(metadata),new Date().toISOString()).run();}\n"
assert needle in s
s=s.replace(needle,repl,1)
# required table and version
s=s.replace("'tournament_share_abuse_windows'];","'tournament_share_abuse_windows','tournament_share_audit'];")
s=s.replace("version:'55.0.0'","version:'56.0.0'")
s=s.replace("v55:'share-health-ux-cache-diagnostics-link-regeneration-route-simulation'","v55:'share-health-ux-cache-diagnostics-link-regeneration-route-simulation',v56:'share-html-etag-rotation-audit-and-public-route-contracts'")
# health add audit
old="return json({share:{id:share.id,views:Number(share.views_count||0),lastViewedAt:share.last_viewed_at,expiresAt:share.expires_at,visibility:share.visibility},health:{status,blockedRequestsLastHour:Number(blocked?.blocked||0),allowedRequestsLastHour:Number(blocked?.allowed||0),rateLimitPerMinute:60},cache:{tournamentJson:'ETag · 60s',replayJson:'ETag · 300s',ogImage:'ETag · 300s',conditional304:'view count is not incremented'}});"
new="const audit=(await env.DB.prepare(`SELECT event,metadata,created_at FROM tournament_share_audit WHERE tournament_id=? ORDER BY created_at DESC LIMIT 10`).bind(id).all<any>()).results||[]; return json({share:{id:share.id,views:Number(share.views_count||0),lastViewedAt:share.last_viewed_at,expiresAt:share.expires_at,visibility:share.visibility},health:{status,blockedRequestsLastHour:Number(blocked?.blocked||0),allowedRequestsLastHour:Number(blocked?.allowed||0),rateLimitPerMinute:60},cache:{html:'ETag · 60s',tournamentJson:'ETag · 60s',replayJson:'ETag · 300s',ogImage:'ETag · 300s',conditional304:'view count is not incremented'},audit});"
assert old in s
s=s.replace(old,new,1)
# POST share replace
old="const existing=await env.DB.prepare(`SELECT id FROM tournament_shares WHERE tournament_id=? AND revoked_at IS NULL LIMIT 1`).bind(id).first<any>(); if(existing) await env.DB.prepare(`UPDATE tournament_shares SET revoked_at=? WHERE id=?`).bind(new Date().toISOString(),existing.id).run();\n        const token=shareToken(),hash=await sha256Hex(token),sid=crypto.randomUUID(),expiresAt=new Date(Date.now()+SHARE_DEFAULT_DAYS*86400000).toISOString(); await env.DB.prepare(`INSERT INTO tournament_shares(id,tournament_id,token_hash,created_by,expires_at,visibility) VALUES(?,?,?,?,?,?)`).bind(sid,id,hash,user.id,expiresAt,'public').run(); return json({ok:true,shareId:sid,token,expiresAt,visibility:'public',publicPath:'/share/tournament/'+encodeURIComponent(token),views:0});"
new="const existing=await env.DB.prepare(`SELECT id FROM tournament_shares WHERE tournament_id=? AND revoked_at IS NULL LIMIT 1`).bind(id).first<any>(); if(existing){await env.DB.prepare(`UPDATE tournament_shares SET revoked_at=? WHERE id=?`).bind(new Date().toISOString(),existing.id).run(); await logShareAudit(env.DB,id,existing.id,'rotated',{reason:'new-token'});}\n        const token=shareToken(),hash=await sha256Hex(token),sid=crypto.randomUUID(),expiresAt=new Date(Date.now()+SHARE_DEFAULT_DAYS*86400000).toISOString(); await env.DB.prepare(`INSERT INTO tournament_shares(id,tournament_id,token_hash,created_by,expires_at,visibility) VALUES(?,?,?,?,?,?)`).bind(sid,id,hash,user.id,expiresAt,'public').run(); await logShareAudit(env.DB,id,sid,'created',{expiresInDays:SHARE_DEFAULT_DAYS,visibility:'public'}); return json({ok:true,shareId:sid,token,expiresAt,visibility:'public',publicPath:'/share/tournament/'+encodeURIComponent(token),views:0});"
assert old in s
s=s.replace(old,new,1)
# PATCH audit
old="await env.DB.prepare(`UPDATE tournament_shares SET visibility=?,expires_at=? WHERE tournament_id=? AND revoked_at IS NULL`).bind(visibility,expiresAt,id).run(); return json({ok:true,visibility,expiresAt});"
new="const active=await env.DB.prepare(`SELECT id FROM tournament_shares WHERE tournament_id=? AND revoked_at IS NULL LIMIT 1`).bind(id).first<any>(); await env.DB.prepare(`UPDATE tournament_shares SET visibility=?,expires_at=? WHERE tournament_id=? AND revoked_at IS NULL`).bind(visibility,expiresAt,id).run(); if(active) await logShareAudit(env.DB,id,active.id,'updated',{expiresInDays:days,visibility}); return json({ok:true,visibility,expiresAt});"
assert old in s
s=s.replace(old,new,1)
# DELETE audit
old="await env.DB.prepare(`UPDATE tournament_shares SET revoked_at=? WHERE tournament_id=? AND revoked_at IS NULL`).bind(new Date().toISOString(),id).run(); return json({ok:true});"
new="const active=await env.DB.prepare(`SELECT id FROM tournament_shares WHERE tournament_id=? AND revoked_at IS NULL LIMIT 1`).bind(id).first<any>(); await env.DB.prepare(`UPDATE tournament_shares SET revoked_at=? WHERE tournament_id=? AND revoked_at IS NULL`).bind(new Date().toISOString(),id).run(); if(active) await logShareAudit(env.DB,id,active.id,'revoked',{}); return json({ok:true});"
assert old in s
s=s.replace(old,new,1)
# HTML route return block and add view accounting; target exact long return
old="return new Response(sharePage(`${t.name} · ZATO Chess`,`ZATO Chess turnuva sonucu · ${description}`,content,publicShareUrl(request,token,selectedMatch?.id,selectedMatch?selectedPly:undefined),`<meta property=\"og:image\" content=\"${htmlEscape(publicOgImageUrl(request,token))}\"><meta name=\"twitter:card\" content=\"summary_large_image\">`),{status:200,headers:{'content-type':'text/html; charset=utf-8','cache-control':'public, max-age=60'}});"
new="const page=sharePage(`${t.name} · ZATO Chess`,`ZATO Chess turnuva sonucu · ${description}`,content,publicShareUrl(request,token,selectedMatch?.id,selectedMatch?selectedPly:undefined),`<meta property=\"og:image\" content=\"${htmlEscape(publicOgImageUrl(request,token))}\"><meta name=\"twitter:card\" content=\"summary_large_image\">`); const response=await cachedHtml(request,page,60); if(response.status===200){await env.DB.prepare(`UPDATE tournament_shares SET views_count=views_count+1,last_viewed_at=? WHERE token_hash=? AND revoked_at IS NULL AND visibility='public' AND (expires_at IS NULL OR expires_at>?)`).bind(new Date().toISOString(),hash,new Date().toISOString()).run(); await env.DB.prepare(`INSERT INTO tournament_share_daily(share_id,day,views) SELECT id,?,1 FROM tournament_shares WHERE token_hash=? ON CONFLICT(share_id,day) DO UPDATE SET views=views+1`).bind(new Date().toISOString().slice(0,10),hash).run();} return response;"
assert old in s
s=s.replace(old,new,1)
p.write_text(s)
# package
pkg=root/'package.json'; d=json.loads(pkg.read_text()); d['version']='56.0.0'; d['scripts']['regression:v56']='node scripts/regression-v56.mjs'; pkg.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n')
# migration
m=root/'db/migrations/V56.sql'; m.write_text("""-- V56 public share audit trail\nCREATE TABLE IF NOT EXISTS tournament_share_audit (\n  id TEXT PRIMARY KEY,\n  tournament_id TEXT NOT NULL,\n  share_id TEXT NOT NULL,\n  event TEXT NOT NULL,\n  metadata TEXT NOT NULL DEFAULT '{}',\n  created_at TEXT NOT NULL\n);\nCREATE INDEX IF NOT EXISTS idx_tournament_share_audit_tournament ON tournament_share_audit(tournament_id, created_at DESC);\nCREATE INDEX IF NOT EXISTS idx_tournament_share_audit_share ON tournament_share_audit(share_id, created_at DESC);\n""")
