import { Chess } from 'chess.js';

export interface Env { ROOMS: DurableObjectNamespace; DB?: D1Database; AUTH_SECRET?: string }
type Color = 'w'|'b';
type Player = { id:string; socket:WebSocket; color:Color; userId:string; username:string; displayName:string; rating:number };
type MoveItem = { from:string; to:string; promotion?:string; color:Color; san:string; ply:number; fen:string; whiteMs:number; blackMs:number };
type RoomPersisted = {
  roomCode:string; gameId:string; fen:string; started:boolean; players:Record<string,Color>; assignments:Record<string,Color>; playerUsers:Record<string,{userId:string;username:string;displayName:string;rating:number}>;
  history:MoveItem[]; whiteMs:number; blackMs:number; turnStartedAt:number|null;
  result:string; startedAt:string; endedAt:string|null;
};

const INITIAL_MS = 10 * 60 * 1000;
const ROOM_CODE_RE = /^[A-Z0-9]{6}$/;

function json(data:unknown, init:ResponseInit={}) {
  return new Response(JSON.stringify(data), { ...init, headers:{'content-type':'application/json; charset=utf-8', ...(init.headers||{})} });
}
function cookie(request:Request,name:string){ const raw=request.headers.get('Cookie')||''; return raw.split(';').map(v=>v.trim()).find(v=>v.startsWith(name+'='))?.slice(name.length+1)||null; }
async function hashPassword(password:string,salt:string){ const key=await crypto.subtle.importKey('raw',new TextEncoder().encode(password),'PBKDF2',false,['deriveBits']); const bits=await crypto.subtle.deriveBits({name:'PBKDF2',salt:new TextEncoder().encode(salt),iterations:120000,hash:'SHA-256'},key,256); return Array.from(new Uint8Array(bits)).map(x=>x.toString(16).padStart(2,'0')).join(''); }
async function authUser(request:Request,env:Env){ if(!env.DB)return null; const sid=cookie(request,'zato_session'); if(!sid)return null; const row=await env.DB.prepare(`SELECT u.id,u.username,u.display_name,u.rating FROM sessions s JOIN users u ON u.id=s.user_id WHERE s.id=? AND s.expires_at>?`).bind(sid,new Date().toISOString()).first<any>(); return row||null; }
function cookieHeaders(){ return 'Path=/; HttpOnly; Secure; SameSite=Lax'; }
function elo(rA:number,rB:number,score:number){ const expected=1/(1+Math.pow(10,(rB-rA)/400)); return Math.round(rA+32*(score-expected)); }

function resultForGame(game:Chess) {
  if (game.isCheckmate()) return game.turn()==='w' ? '0-1' : '1-0';
  if (game.isDraw()) return '1/2-1/2';
  return '*';
}

export default {
  async fetch(request:Request, env:Env):Promise<Response> {
    const url = new URL(request.url);
    const analysisMatch = url.pathname.match(/^\/api\/games\/([^/]+)\/analysis$/);
    if (analysisMatch && request.method === 'POST') {
      if(!env.DB) return json({error:'D1 yapılandırılmamış.'},{status:503});
      const user=await authUser(request,env); if(!user)return json({error:'Giriş gerekli.'},{status:401});
      try {
        const gameId=decodeURIComponent(analysisMatch[1]);
        const owned=await env.DB.prepare('SELECT id FROM games WHERE id=? AND (white_user_id=? OR black_user_id=?)').bind(gameId,user.id,user.id).first();
        if(!owned)return json({error:'Maç bulunamadı.'},{status:404});
        const body=await request.json() as any; const rows=Array.isArray(body.analysis)?body.analysis:[];
        const stmts=rows.slice(0,500).map((x:any)=>env.DB!.prepare(`INSERT OR REPLACE INTO analyses(game_id,ply,engine,depth,score_cp,mate,best_move_uci,classification,explanation) VALUES(?,?,?,?,?,?,?,?,?)`).bind(gameId,Number(x.ply), 'Stockfish 19', Number(x.depth)||null, Number.isFinite(x.score_cp)?Number(x.score_cp):null, null, x.best_move_uci||null, String(x.classification||'').slice(0,32), `Centipawn loss: ${Number(x.loss)||0}`));
        if(stmts.length) await env.DB.batch(stmts);
        return json({ok:true,count:stmts.length});
      } catch { return json({error:'Analiz kaydedilemedi.'},{status:400}); }
    }

    if (url.pathname === '/api/puzzles/stats' && request.method === 'GET') {
      if(!env.DB) return json({error:'D1 yapılandırılmamış.'},{status:503});
      const user=await authUser(request,env); if(!user)return json({error:'Giriş gerekli.'},{status:401});
      const row=await env.DB.prepare('SELECT puzzle_rating,solved_count,attempt_count,current_streak,best_streak,last_solved_date FROM puzzle_stats WHERE user_id=?').bind(user.id).first<any>();
      return json({stats:row||{puzzle_rating:1200,solved_count:0,attempt_count:0,current_streak:0,best_streak:0,last_solved_date:null}});
    }
    if (url.pathname === '/api/puzzles/daily' && request.method === 'GET') {
      if(!env.DB) return json({error:'D1 yapılandırılmamış.'},{status:503});
      const user=await authUser(request,env); if(!user)return json({error:'Giriş gerekli.'},{status:401});
      const date=new Date().toISOString().slice(0,10);
      let daily=await env.DB.prepare('SELECT puzzle_id FROM puzzle_daily WHERE puzzle_date=?').bind(date).first<any>();
      if(!daily){
        const picked=await env.DB.prepare('SELECT id FROM puzzles ORDER BY RANDOM() LIMIT 1').first<any>();
        if(!picked)return json({error:'Henüz puzzle eklenmemiş.'},{status:404});
        await env.DB.prepare('INSERT OR IGNORE INTO puzzle_daily(puzzle_date,puzzle_id) VALUES(?,?)').bind(date,picked.id).run();
        daily={puzzle_id:picked.id};
      }
      const row=await env.DB.prepare('SELECT id,fen,moves,solution_uci,solution_san,rating,difficulty,theme FROM puzzles WHERE id=?').bind(daily.puzzle_id).first<any>();
      const solved=await env.DB.prepare('SELECT 1 FROM puzzle_attempts WHERE puzzle_id=? AND user_id=? AND solved=1 LIMIT 1').bind(daily.puzzle_id,user.id).first();
      return json({date,solved:Boolean(solved),puzzle:{id:row.id,fen:row.fen,moves:JSON.parse(row.moves||'[]'),solutionUci:JSON.parse(row.solution_uci||'[]'),solutionSan:JSON.parse(row.solution_san||'[]'),rating:row.rating,difficulty:row.difficulty,theme:row.theme}});
    }
    if (url.pathname === '/api/puzzles/random' && request.method === 'GET') {
      if(!env.DB) return json({error:'D1 yapılandırılmamış.'},{status:503});
      const user=await authUser(request,env); if(!user)return json({error:'Giriş gerekli.'},{status:401});
      const row=await env.DB.prepare(`SELECT id,fen,moves,solution_uci,solution_san,rating,difficulty,theme FROM puzzles ORDER BY RANDOM() LIMIT 1`).first<any>();
      if(!row)return json({error:'Henüz puzzle eklenmemiş.'},{status:404});
      return json({puzzle:{id:row.id,fen:row.fen,moves:JSON.parse(row.moves||'[]'),solutionUci:JSON.parse(row.solution_uci||'[]'),solutionSan:JSON.parse(row.solution_san||'[]'),rating:row.rating,difficulty:row.difficulty,theme:row.theme}});
    }
    if (url.pathname === '/api/puzzles/attempt' && request.method === 'POST') {
      if(!env.DB) return json({error:'D1 yapılandırılmamış.'},{status:503});
      const user=await authUser(request,env); if(!user)return json({error:'Giriş gerekli.'},{status:401});
      try {
        const body=await request.json() as any; const puzzleId=String(body.puzzleId||''); const solved=Boolean(body.solved); const elapsed=Math.max(0,Math.min(3600000,Number(body.elapsedMs)||0));
        const puzzle=await env.DB.prepare('SELECT id FROM puzzles WHERE id=?').bind(puzzleId).first(); if(!puzzle)return json({error:'Puzzle bulunamadı.'},{status:404});
        await env.DB.prepare(`INSERT INTO puzzle_attempts(puzzle_id,user_id,solved,elapsed_ms) VALUES(?,?,?,?)`).bind(puzzleId,user.id,solved?1:0,elapsed).run();
        const today=new Date().toISOString().slice(0,10);
        const stats=await env.DB.prepare('SELECT * FROM puzzle_stats WHERE user_id=?').bind(user.id).first<any>();
        if(!stats) await env.DB.prepare('INSERT INTO puzzle_stats(user_id) VALUES(?)').bind(user.id).run();
        if(solved){
          const current=stats||{puzzle_rating:1200,solved_count:0,attempt_count:0,current_streak:0,best_streak:0,last_solved_date:null};
          const prev=current.last_solved_date;
          const yesterday=new Date(Date.now()-86400000).toISOString().slice(0,10);
          const streak=prev===yesterday ? Number(current.current_streak)+1 : prev===today ? Number(current.current_streak) : 1;
          const delta=elapsed<=30000?12:elapsed<=90000?8:5;
          const rating=Math.max(400,Math.min(3000,Number(current.puzzle_rating)+delta));
          await env.DB.prepare(`UPDATE puzzle_stats SET puzzle_rating=?,solved_count=solved_count+1,attempt_count=attempt_count+1,current_streak=?,best_streak=MAX(best_streak,?),last_solved_date=? WHERE user_id=?`).bind(rating,streak,streak,today,user.id).run();
        } else {
          await env.DB.prepare('UPDATE puzzle_stats SET attempt_count=attempt_count+1 WHERE user_id=?').bind(user.id).run();
        }
        const updated=await env.DB.prepare('SELECT puzzle_rating,solved_count,attempt_count,current_streak,best_streak,last_solved_date FROM puzzle_stats WHERE user_id=?').bind(user.id).first<any>();
        return json({ok:true,stats:updated});
      } catch { return json({error:'Puzzle sonucu kaydedilemedi.'},{status:400}); }
    }
    if (url.pathname === '/api/auth/me' && request.method === 'GET') {
      const user=await authUser(request,env); return json({authenticated:Boolean(user),user:user||null});
    }
    if (url.pathname === '/api/auth/register' && request.method === 'POST') {
      if(!env.DB) return json({error:'D1 yapılandırılmamış.'},{status:503});
      try { const body=await request.json() as any; const username=String(body.username||'').trim().toLowerCase(); const displayName=String(body.displayName||username).trim(); const password=String(body.password||'');
        if(!/^[a-z0-9_]{3,20}$/.test(username)||displayName.length<2||displayName.length>32||password.length<8) return json({error:'Kullanıcı adı 3-20 karakter, şifre en az 8 karakter olmalı.'},{status:400});
        const exists=await env.DB.prepare('SELECT id FROM users WHERE username=?').bind(username).first(); if(exists)return json({error:'Bu kullanıcı adı zaten kayıtlı.'},{status:409});
        const id=crypto.randomUUID(), salt=crypto.randomUUID(), passwordHash=await hashPassword(password,salt); await env.DB.prepare('INSERT INTO users(id,username,display_name,password_hash,password_salt) VALUES(?,?,?,?,?)').bind(id,username,displayName,passwordHash,salt).run();
        const sid=crypto.randomUUID(); const exp=new Date(Date.now()+30*24*60*60*1000).toISOString(); await env.DB.prepare('INSERT INTO sessions(id,user_id,expires_at) VALUES(?,?,?)').bind(sid,id,exp).run();
        const user=await env.DB.prepare('SELECT id,username,display_name,rating FROM users WHERE id=?').bind(id).first(); return json({user},{headers:{'Set-Cookie':`zato_session=${sid}; ${cookieHeaders()}; Max-Age=2592000`}});
      } catch { return json({error:'Kayıt işlemi başarısız.'},{status:400}); }
    }
    if (url.pathname === '/api/auth/login' && request.method === 'POST') {
      if(!env.DB)return json({error:'D1 yapılandırılmamış.'},{status:503});
      try { const body=await request.json() as any; const username=String(body.username||'').trim().toLowerCase(); const password=String(body.password||''); const row=await env.DB.prepare('SELECT * FROM users WHERE username=?').bind(username).first<any>(); if(!row)return json({error:'Kullanıcı adı veya şifre hatalı.'},{status:401}); const hash=await hashPassword(password,row.password_salt); if(hash!==row.password_hash)return json({error:'Kullanıcı adı veya şifre hatalı.'},{status:401}); const sid=crypto.randomUUID(),exp=new Date(Date.now()+30*24*60*60*1000).toISOString(); await env.DB.prepare('INSERT INTO sessions(id,user_id,expires_at) VALUES(?,?,?)').bind(sid,row.id,exp).run(); return json({user:{id:row.id,username:row.username,display_name:row.display_name,rating:row.rating}},{headers:{'Set-Cookie':`zato_session=${sid}; ${cookieHeaders()}; Max-Age=2592000`}}); } catch { return json({error:'Giriş işlemi başarısız.'},{status:400}); }
    }
    if (url.pathname === '/api/players' && request.method === 'GET') {
      if(!env.DB) return json({error:'D1 yapılandırılmamış.'},{status:503});
      const user=await authUser(request,env); if(!user)return json({error:'Giriş gerekli.'},{status:401});
      const q=(url.searchParams.get('q')||'').trim().toLowerCase();
      if(q.length<2) return json({players:[]});
      const rows=await env.DB.prepare(`SELECT id,username,display_name,rating FROM users WHERE id<>? AND (username LIKE ? OR display_name LIKE ?) ORDER BY rating DESC LIMIT 20`).bind(user.id,`%${q}%`,`%${q}%`).all();
      return json({players:rows.results||[]});
    }
    if (url.pathname === '/api/friends' && request.method === 'GET') {
      if(!env.DB) return json({error:'D1 yapılandırılmamış.'},{status:503});
      const user=await authUser(request,env); if(!user)return json({error:'Giriş gerekli.'},{status:401});
      const rows=await env.DB.prepare(`SELECT f.user_id,f.friend_id,f.status,f.created_at,u.username,u.display_name,u.rating FROM friendships f JOIN users u ON u.id=CASE WHEN f.user_id=? THEN f.friend_id ELSE f.user_id END WHERE (f.user_id=? OR f.friend_id=?) ORDER BY f.updated_at DESC`).bind(user.id,user.id,user.id).all();
      return json({friends:rows.results||[]});
    }
    if (url.pathname === '/api/friends/request' && request.method === 'POST') {
      if(!env.DB) return json({error:'D1 yapılandırılmamış.'},{status:503});
      const user=await authUser(request,env); if(!user)return json({error:'Giriş gerekli.'},{status:401});
      try { const body=await request.json() as any; const friendId=String(body.userId||''); if(!friendId||friendId===user.id)return json({error:'Geçersiz oyuncu.'},{status:400});
        const target=await env.DB.prepare('SELECT id FROM users WHERE id=?').bind(friendId).first(); if(!target)return json({error:'Oyuncu bulunamadı.'},{status:404});
        const existing=await env.DB.prepare('SELECT user_id,friend_id,status FROM friendships WHERE (user_id=? AND friend_id=?) OR (user_id=? AND friend_id=?)').bind(user.id,friendId,friendId,user.id).first<any>();
        if(existing?.status==='accepted')return json({error:'Zaten arkadaşsınız.'},{status:409});
        if(existing?.status==='pending')return json({error:'Bekleyen arkadaşlık isteği var.'},{status:409});
        await env.DB.prepare(`INSERT OR REPLACE INTO friendships(user_id,friend_id,status,updated_at) VALUES(?,?,?,CURRENT_TIMESTAMP)`).bind(user.id,friendId,'pending').run();
        return json({ok:true,status:'pending'});
      } catch { return json({error:'Arkadaşlık isteği gönderilemedi.'},{status:400}); }
    }
    if (url.pathname === '/api/friends/respond' && request.method === 'POST') {
      if(!env.DB) return json({error:'D1 yapılandırılmamış.'},{status:503});
      const user=await authUser(request,env); if(!user)return json({error:'Giriş gerekli.'},{status:401});
      try { const body=await request.json() as any; const fromId=String(body.userId||''); const accepted=Boolean(body.accepted); if(!fromId||fromId===user.id)return json({error:'Geçersiz oyuncu.'},{status:400});
        const reqRow=await env.DB.prepare(`SELECT status FROM friendships WHERE user_id=? AND friend_id=?`).bind(fromId,user.id).first<any>();
        if(!reqRow||reqRow.status!=='pending')return json({error:'İstek bulunamadı.'},{status:404});
        if(accepted){ await env.DB.batch([env.DB.prepare(`UPDATE friendships SET status='accepted',updated_at=CURRENT_TIMESTAMP WHERE user_id=? AND friend_id=?`).bind(fromId,user.id),env.DB.prepare(`INSERT OR REPLACE INTO friendships(user_id,friend_id,status,updated_at) VALUES(?,?,?,CURRENT_TIMESTAMP)`).bind(user.id,fromId,'accepted')]); }
        else await env.DB.prepare(`DELETE FROM friendships WHERE user_id=? AND friend_id=?`).bind(fromId,user.id).run();
        return json({ok:true,status:accepted?'accepted':'rejected'});
      } catch { return json({error:'İstek yanıtlanamadı.'},{status:400}); }
    }
    if (url.pathname === '/api/invites' && request.method === 'GET') {
      if(!env.DB) return json({error:'D1 yapılandırılmamış.'},{status:503});
      const user=await authUser(request,env); if(!user)return json({error:'Giriş gerekli.'},{status:401});
      await env.DB.prepare("UPDATE game_invites SET status='expired' WHERE to_user_id=? AND status='pending' AND expires_at<=?").bind(user.id,new Date().toISOString()).run();
      const rows=await env.DB.prepare(`SELECT i.id,i.room_code,i.created_at,i.expires_at,u.id as user_id,u.username,u.display_name,u.rating FROM game_invites i JOIN users u ON u.id=i.from_user_id WHERE i.to_user_id=? AND i.status='pending' ORDER BY i.created_at DESC LIMIT 20`).bind(user.id).all();
      return json({invites:rows.results||[]});
    }
    if (url.pathname === '/api/invites/create' && request.method === 'POST') {
      if(!env.DB) return json({error:'D1 yapılandırılmamış.'},{status:503});
      const user=await authUser(request,env); if(!user)return json({error:'Giriş gerekli.'},{status:401});
      try { const body=await request.json() as any; const toId=String(body.userId||''); if(!toId||toId===user.id)return json({error:'Geçersiz oyuncu.'},{status:400});
        const friend=await env.DB.prepare("SELECT 1 FROM friendships WHERE user_id=? AND friend_id=? AND status='accepted'").bind(user.id,toId).first();
        if(!friend)return json({error:'Yalnızca arkadaşlarına davet gönderebilirsin.'},{status:403});
        const target=await env.DB.prepare('SELECT id FROM users WHERE id=?').bind(toId).first(); if(!target)return json({error:'Oyuncu bulunamadı.'},{status:404});
        const existing=await env.DB.prepare("SELECT id FROM game_invites WHERE from_user_id=? AND to_user_id=? AND status='pending'").bind(user.id,toId).first();
        if(existing)return json({error:'Bu oyuncuya zaten bekleyen davet var.'},{status:409});
        const id=crypto.randomUUID(), code=crypto.randomUUID().replaceAll('-','').slice(0,6).toUpperCase(), expires=new Date(Date.now()+10*60*1000).toISOString();
        await env.DB.prepare('INSERT INTO game_invites(id,from_user_id,to_user_id,room_code,expires_at) VALUES(?,?,?,?,?)').bind(id,user.id,toId,code,expires).run();
        return json({ok:true,id,roomCode:code,expiresAt:expires});
      } catch { return json({error:'Davet oluşturulamadı.'},{status:400}); }
    }
    if (url.pathname === '/api/invites/respond' && request.method === 'POST') {
      if(!env.DB) return json({error:'D1 yapılandırılmamış.'},{status:503});
      const user=await authUser(request,env); if(!user)return json({error:'Giriş gerekli.'},{status:401});
      try { const body=await request.json() as any; const id=String(body.id||''); const accepted=Boolean(body.accepted);
        const inv=await env.DB.prepare("SELECT id,room_code,expires_at FROM game_invites WHERE id=? AND to_user_id=? AND status='pending'").bind(id,user.id).first<any>();
        if(!inv)return json({error:'Davet bulunamadı.'},{status:404});
        if(new Date(inv.expires_at).getTime()<=Date.now()){await env.DB.prepare("UPDATE game_invites SET status='expired' WHERE id=?").bind(id).run();return json({error:'Davetin süresi dolmuş.'},{status:410});}
        await env.DB.prepare('UPDATE game_invites SET status=? WHERE id=?').bind(accepted?'accepted':'declined',id).run();
        return json({ok:true,status:accepted?'accepted':'declined',roomCode:accepted?inv.room_code:null});
      } catch { return json({error:'Davet yanıtlanamadı.'},{status:400}); }
    }
    if (url.pathname === '/api/friends/remove' && request.method === 'POST') {
      if(!env.DB) return json({error:'D1 yapılandırılmamış.'},{status:503});
      const user=await authUser(request,env); if(!user)return json({error:'Giriş gerekli.'},{status:401});
      try { const body=await request.json() as any; const other=String(body.userId||''); await env.DB.batch([env.DB.prepare('DELETE FROM friendships WHERE user_id=? AND friend_id=?').bind(user.id,other),env.DB.prepare('DELETE FROM friendships WHERE user_id=? AND friend_id=?').bind(other,user.id)]); return json({ok:true}); } catch { return json({error:'Arkadaş silinemedi.'},{status:400}); }
    }
    if (url.pathname === '/api/auth/logout' && request.method === 'POST') { if(env.DB){const sid=cookie(request,'zato_session'); if(sid)await env.DB.prepare('DELETE FROM sessions WHERE id=?').bind(sid).run();} return new Response(null,{status:204,headers:{'Set-Cookie':`zato_session=; ${cookieHeaders()}; Max-Age=0`}}); }

    if (url.pathname === '/api/room' && request.method === 'POST') {
      const user=await authUser(request,env); if(!user)return json({error:'Online oyun için giriş yapmalısınız.'},{status:401});
      const code = crypto.randomUUID().replaceAll('-', '').slice(0,6).toUpperCase();
      return json({code, websocket:`/ws/${code}`});
    }
    if (url.pathname.startsWith('/ws/')) {
      const code = (url.pathname.split('/').pop() || '').toUpperCase();
      if (!ROOM_CODE_RE.test(code)) return json({type:'room:error',message:'Geçersiz oda kodu.'},{status:400});
      const user=await authUser(request,env); if(!user)return json({error:'Online oyun için giriş yapmalısınız.'},{status:401});
      const forwarded=new Request(request,{headers:new Headers(request.headers)}); forwarded.headers.set('x-zato-user-id',user.id); forwarded.headers.set('x-zato-username',user.username); forwarded.headers.set('x-zato-display-name',user.display_name); forwarded.headers.set('x-zato-rating',String(user.rating));
      return env.ROOMS.get(env.ROOMS.idFromName(code)).fetch(forwarded);
    }
    return new Response('ZATO Chess Worker',{headers:{'content-type':'text/plain; charset=utf-8'}});
  }
};

export class RoomDurableObject {
  private state:DurableObjectState;
  private env:Env;
  private players = new Map<string,Player>();
  private game = new Chess();
  private history:MoveItem[] = [];
  private whiteMs = INITIAL_MS;
  private blackMs = INITIAL_MS;
  private turnStartedAt:number|null = null;
  private result = '*';
  private roomCode = '';
  private gameId = '';
  private startedAt = '';
  private assignments:Record<string,Color> = {};
  private playerUsers:Record<string,{userId:string;username:string;displayName:string;rating:number}> = {};
  private endedAt:string|null = null;
  private initialized = false;

  constructor(state:DurableObjectState, env:Env) { this.state=state; this.env=env; }

  private async init(request?:Request) {
    if (this.initialized) return;
    this.roomCode = request ? (new URL(request.url).pathname.split('/').pop()||'').toUpperCase() : '';
    const saved = await this.state.storage.get<RoomPersisted>('room');
    if (saved) {
      this.roomCode=saved.roomCode||this.roomCode; this.gameId=saved.gameId||crypto.randomUUID();
      try { this.game=new Chess(saved.fen); } catch { this.game=new Chess(); }
      this.history=saved.history||[]; this.assignments=saved.assignments||saved.players||{}; this.playerUsers=saved.playerUsers||{}; this.whiteMs=saved.whiteMs??INITIAL_MS; this.blackMs=saved.blackMs??INITIAL_MS;
      this.turnStartedAt=saved.turnStartedAt??null; this.result=saved.result||'*'; this.startedAt=saved.startedAt||new Date().toISOString(); this.endedAt=saved.endedAt||null;
    } else { this.gameId=crypto.randomUUID(); this.startedAt=new Date().toISOString(); }
    this.initialized=true;
  }

  async fetch(request:Request):Promise<Response> {
    await this.init(request);
    if (request.headers.get('Upgrade') !== 'websocket') return new Response('WebSocket required',{status:426});
    if (this.players.size>=2) return json({type:'room:error',message:'Oda dolu.'},{status:409});

    const url=new URL(request.url);
    const userId=request.headers.get('x-zato-user-id'); const username=request.headers.get('x-zato-username')||''; const displayName=request.headers.get('x-zato-display-name')||username; const rating=Number(request.headers.get('x-zato-rating')||1200); if(!userId)return json({type:'room:error',message:'Giriş gerekli.'},{status:401}); const requestedId=url.searchParams.get('playerId');
    const restoredColor=requestedId ? this.assignments[requestedId] || null : null;
    const id=requestedId && restoredColor ? requestedId : crypto.randomUUID();
    if (this.players.has(id)) return json({type:'room:error',message:'Oyuncu zaten bağlı.'},{status:409});
    const activeColors=new Set([...this.players.values()].map(p=>p.color));
    const color:Color = restoredColor || (!activeColors.has('w') && !Object.values(this.assignments).includes('w') ? 'w' : !activeColors.has('b') && !Object.values(this.assignments).includes('b') ? 'b' : 'b');
    if (!restoredColor && Object.values(this.assignments).includes(color)) return json({type:'room:error',message:'Oda koltukları dolu. Mevcut oyuncu playerId ile yeniden bağlanmalı.'},{status:409});
    this.assignments[id]=color;

    const pair=new WebSocketPair(); const client=pair[0], server=pair[1]; server.accept();
    this.players.set(id,{id,socket:server,color,userId,username,displayName,rating}); this.playerUsers[id]={userId,username,displayName,rating};
    const started=this.players.size===2 && this.result==='*';
    if (started && this.turnStartedAt===null) { this.turnStartedAt=Date.now(); await this.armClock(); }
    await this.persist();

    server.send(JSON.stringify({type:'room:joined',playerId:id,user:{id:userId,username,displayName,rating},color,members:this.players.size,started,fen:this.game.fen(),turn:this.game.turn(),history:this.history,result:this.result,whiteMs:this.currentClock('w'),blackMs:this.currentClock('b'),startedAt:this.startedAt}));
    this.broadcast({type:'room:state',members:this.players.size,started,fen:this.game.fen(),turn:this.game.turn(),result:this.result,history:this.history,whiteMs:this.currentClock('w'),blackMs:this.currentClock('b')});

    server.addEventListener('message', async e=>{
      try {
        const msg=JSON.parse(String(e.data)); const player=this.players.get(id);
        if (!player || !msg || typeof msg.type!=='string') return;
        if (msg.type==='game:move') {
          if (this.players.size<2 || this.result!=='*') return this.sendError(server,'Maç aktif değil.');
          if (msg.color!==player.color) return this.sendError(server,'Renk eşleşmesi geçersiz.');
          if (this.game.turn()!==player.color) return this.sendError(server,'Sıra rakibinizde.');
          if (this.currentClock(player.color)<=0) return this.finishByTime(player.color,id);
          if (typeof msg.from!=='string'||typeof msg.to!=='string') return this.sendError(server,'Hamle formatı geçersiz.');
          let move; try { move=this.game.move({from:msg.from,to:msg.to,promotion:msg.promotion||undefined}); } catch { move=null; }
          if (!move) return this.sendError(server,'Geçersiz hamle.');
          this.consumeClock(move.color);
          const item:MoveItem={from:move.from,to:move.to,promotion:move.promotion,color:move.color,san:move.san,ply:this.history.length+1,fen:this.game.fen(),whiteMs:this.currentClock('w'),blackMs:this.currentClock('b')};
          this.history.push(item); this.result=resultForGame(this.game);
          if (this.result==='*') { this.turnStartedAt=Date.now(); await this.armClock(); }
          else { this.turnStartedAt=null; await this.state.storage.deleteAlarm(); this.endedAt=new Date().toISOString(); await this.persistCompletedGame(); }
          await this.persist();
          this.broadcast({type:'game:state',history:this.history,fen:this.game.fen(),turn:this.game.turn(),result:this.result,whiteMs:this.currentClock('w'),blackMs:this.currentClock('b'),lastMove:item});
          if (this.result!=='*') this.broadcast({type:'game:over',result:this.result,reason:'rules',whiteMs:this.currentClock('w'),blackMs:this.currentClock('b')});
        } else if (msg.type==='game:resign') {
          if (this.result!=='*') return;
          this.consumeClock(player.color); this.result=player.color==='w'?'0-1':'1-0'; this.turnStartedAt=null; this.endedAt=new Date().toISOString(); await this.state.storage.deleteAlarm(); await this.persist(); await this.persistCompletedGame();
          this.broadcast({type:'game:over',result:this.result,reason:'resign',fromPlayer:id,whiteMs:this.currentClock('w'),blackMs:this.currentClock('b')});
        } else if (msg.type==='game:draw-offer') {
          if (this.result==='*') this.broadcastExcept(id,{type:'game:draw-offer',fromPlayer:id});
        } else if (msg.type==='game:draw-response') {
          if (this.result!=='*') return;
          if (msg.accepted) { this.result='1/2-1/2'; this.turnStartedAt=null; this.endedAt=new Date().toISOString(); await this.state.storage.deleteAlarm(); await this.persist(); await this.persistCompletedGame(); this.broadcast({type:'game:over',result:this.result,reason:'draw',whiteMs:this.currentClock('w'),blackMs:this.currentClock('b')}); }
          else this.broadcastExcept(id,{type:'game:draw-response',accepted:false,fromPlayer:id});
        } else if (msg.type==='room:ping') {
          server.send(JSON.stringify({type:'room:pong',at:Date.now(),whiteMs:this.currentClock('w'),blackMs:this.currentClock('b'),turn:this.game.turn()}));
        }
      } catch { this.sendError(server,'Geçersiz mesaj.'); }
    });

    const close=async()=>{ this.players.delete(id); await this.persist(); this.broadcast({type:'room:state',members:this.players.size,started:this.players.size===2&&this.result==='*',fen:this.game.fen(),turn:this.game.turn(),result:this.result,history:this.history,whiteMs:this.currentClock('w'),blackMs:this.currentClock('b')}); };
    server.addEventListener('close',()=>{void close();}); server.addEventListener('error',()=>{void close();});
    return new Response(null,{status:101,webSocket:client});
  }

  async alarm() {
    await this.init();
    if (this.result!=='*'||this.turnStartedAt===null) return;
    const color=this.game.turn();
    if (this.currentClock(color)<=0) await this.finishByTime(color,'system'); else await this.armClock();
  }

  private currentClock(color:Color) {
    const base=color==='w'?this.whiteMs:this.blackMs;
    if (this.turnStartedAt!==null && this.result==='*' && this.game.turn()===color) return Math.max(0,base-(Date.now()-this.turnStartedAt));
    return Math.max(0,base);
  }
  private consumeClock(color:Color) { if (this.turnStartedAt!==null) { const elapsed=Math.max(0,Date.now()-this.turnStartedAt); if(color==='w') this.whiteMs=Math.max(0,this.whiteMs-elapsed); else this.blackMs=Math.max(0,this.blackMs-elapsed); } this.turnStartedAt=null; }
  private async armClock() { if(this.turnStartedAt===null)return; const ms=this.currentClock(this.game.turn()); await this.state.storage.setAlarm(Date.now()+ms+50); }
  private async finishByTime(color:Color,fromPlayer:string) { this.consumeClock(color); this.result=color==='w'?'0-1':'1-0'; this.endedAt=new Date().toISOString(); await this.state.storage.deleteAlarm(); await this.persist(); await this.persistCompletedGame(); this.broadcast({type:'game:over',result:this.result,reason:'timeout',fromPlayer,whiteMs:this.currentClock('w'),blackMs:this.currentClock('b')}); }
  private sendError(socket:WebSocket,message:string){try{socket.send(JSON.stringify({type:'room:error',message}));}catch{}}
  private async persist(){ await this.state.storage.put<RoomPersisted>('room',{roomCode:this.roomCode,gameId:this.gameId,fen:this.game.fen(),started:this.players.size===2&&this.result==='*',players:Object.fromEntries([...this.players].map(([id,p])=>[id,p.color])),assignments:this.assignments,playerUsers:this.playerUsers,history:this.history,whiteMs:this.whiteMs,blackMs:this.blackMs,turnStartedAt:this.turnStartedAt,result:this.result,startedAt:this.startedAt,endedAt:this.endedAt}); }
  private async persistCompletedGame(){ if(!this.env.DB||this.result==='*')return; try { const vals=Object.values(this.playerUsers); const whiteId=Object.entries(this.assignments).find(([,c])=>c==='w')?.[0]; const blackId=Object.entries(this.assignments).find(([,c])=>c==='b')?.[0]; const wu=whiteId?this.playerUsers[whiteId]:null; const bu=blackId?this.playerUsers[blackId]:null; await this.env.DB.prepare(`INSERT OR REPLACE INTO games (id,white_user_id,black_user_id,white_name,black_name,time_control,result,status,pgn,initial_fen,final_fen,started_at,ended_at) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)`).bind(this.gameId,wu?.userId||null,bu?.userId||null,wu?.displayName||'ZATO White',bu?.displayName||'ZATO Black','10+0',this.result,'finished',this.game.pgn({maxWidth:80,newline:'\n'}),'startpos',this.game.fen(),this.startedAt,this.endedAt||new Date().toISOString()).run(); for(const m of this.history){ await this.env.DB.prepare(`INSERT OR REPLACE INTO moves (game_id,ply,san,uci,fen_after,clock_white,clock_black) VALUES (?,?,?,?,?,?,?)`).bind(this.gameId,m.ply,m.san,`${m.from}${m.to}${m.promotion||''}`,m.fen,m.whiteMs,m.blackMs).run(); }
      if(wu&&bu){ const scoreW=this.result==='1-0'?1:this.result==='1/2-1/2'?0.5:0; const nw=elo(wu.rating,bu.rating,scoreW), nb=elo(bu.rating,wu.rating,1-scoreW); await this.env.DB.batch([this.env.DB.prepare(`UPDATE users SET rating=?,games_played=games_played+1,wins=wins+?,draws=draws+?,losses=losses+? WHERE id=?`).bind(nw,scoreW===1?1:0,scoreW===0.5?1:0,scoreW===0?1:0,wu.userId),this.env.DB.prepare(`UPDATE users SET rating=?,games_played=games_played+1,wins=wins+?,draws=draws+?,losses=losses+? WHERE id=?`).bind(nb,scoreW===0?1:0,scoreW===0.5?1:0,scoreW===1?1:0,bu.userId)]); }
    } catch(e){ await this.state.storage.put('d1_error',String(e)); } }
  private broadcast(message:unknown){const data=JSON.stringify(message);for(const {socket} of this.players.values()){try{socket.send(data);}catch{}}}
  private broadcastExcept(excludeId:string,message:unknown){const data=JSON.stringify(message);for(const [id,{socket}] of this.players){if(id!==excludeId)try{socket.send(data);}catch{}}}
}
