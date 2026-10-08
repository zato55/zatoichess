-- ZATO Chess V93 D1 initial setup
-- Empty D1 only.


-- ===== db/schema.sql =====
-- ZATO Chess V17 persistent schema
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  display_name TEXT NOT NULL,
  password_hash TEXT NOT NULL DEFAULT '',
  password_salt TEXT NOT NULL DEFAULT '',
  rating INTEGER NOT NULL DEFAULT 1200,
  games_played INTEGER NOT NULL DEFAULT 0,
  wins INTEGER NOT NULL DEFAULT 0,
  draws INTEGER NOT NULL DEFAULT 0,
  losses INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS games (
  id TEXT PRIMARY KEY,
  white_user_id TEXT,
  black_user_id TEXT,
  white_name TEXT NOT NULL,
  black_name TEXT NOT NULL,
  time_control TEXT NOT NULL,
  result TEXT NOT NULL DEFAULT '*',
  status TEXT NOT NULL DEFAULT 'playing',
  pgn TEXT NOT NULL DEFAULT '',
  initial_fen TEXT NOT NULL DEFAULT 'startpos',
  final_fen TEXT,
  started_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ended_at TEXT,
  FOREIGN KEY (white_user_id) REFERENCES users(id),
  FOREIGN KEY (black_user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS moves (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  game_id TEXT NOT NULL,
  ply INTEGER NOT NULL,
  san TEXT NOT NULL,
  uci TEXT NOT NULL,
  fen_after TEXT NOT NULL,
  clock_white INTEGER,
  clock_black INTEGER,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(game_id, ply),
  FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS analyses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  game_id TEXT NOT NULL,
  ply INTEGER NOT NULL,
  engine TEXT NOT NULL,
  depth INTEGER,
  score_cp INTEGER,
  mate INTEGER,
  best_move_uci TEXT,
  best_line TEXT,
  classification TEXT,
  explanation TEXT,
  loss_cp INTEGER DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(game_id, ply, engine),
  FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_games_white ON games(white_user_id, started_at DESC);
CREATE INDEX IF NOT EXISTS idx_games_black ON games(black_user_id, started_at DESC);
CREATE INDEX IF NOT EXISTS idx_moves_game ON moves(game_id, ply);
CREATE INDEX IF NOT EXISTS idx_analysis_game ON analyses(game_id, ply);


CREATE TABLE IF NOT EXISTS sessions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  expires_at TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS room_events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  room_code TEXT NOT NULL,
  user_id TEXT,
  event_type TEXT NOT NULL,
  payload_json TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_sessions_user ON sessions(user_id);

CREATE TABLE IF NOT EXISTS user_presence (
  user_id TEXT PRIMARY KEY,
  session_id TEXT NOT NULL,
  last_seen_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_presence_last_seen ON user_presence(last_seen_at);
CREATE INDEX IF NOT EXISTS idx_room_events_room ON room_events(room_code, id);


CREATE TABLE IF NOT EXISTS friendships (
  user_id TEXT NOT NULL,
  friend_id TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, friend_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (friend_id) REFERENCES users(id) ON DELETE CASCADE,
  CHECK (user_id <> friend_id),
  CHECK (status IN ('pending','accepted','blocked'))
);
CREATE INDEX IF NOT EXISTS idx_friendships_user_status ON friendships(user_id,status);
CREATE INDEX IF NOT EXISTS idx_friendships_friend_status ON friendships(friend_id,status);


CREATE TABLE IF NOT EXISTS puzzles (
  id TEXT PRIMARY KEY,
  fen TEXT NOT NULL,
  moves TEXT NOT NULL DEFAULT '[]',
  solution_uci TEXT NOT NULL DEFAULT '[]',
  solution_san TEXT NOT NULL DEFAULT '[]',
  rating INTEGER NOT NULL DEFAULT 1200,
  difficulty TEXT NOT NULL DEFAULT 'medium',
  theme TEXT NOT NULL DEFAULT 'tactics',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_puzzles_rating ON puzzles(rating);
CREATE TABLE IF NOT EXISTS puzzle_attempts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  puzzle_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  solved INTEGER NOT NULL DEFAULT 0,
  elapsed_ms INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (puzzle_id) REFERENCES puzzles(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_puzzle_attempts_user ON puzzle_attempts(user_id,created_at DESC);

CREATE TABLE IF NOT EXISTS puzzle_daily (
  puzzle_date TEXT PRIMARY KEY,
  puzzle_id TEXT NOT NULL,
  FOREIGN KEY (puzzle_id) REFERENCES puzzles(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS puzzle_stats (
  user_id TEXT PRIMARY KEY,
  puzzle_rating INTEGER NOT NULL DEFAULT 1200,
  solved_count INTEGER NOT NULL DEFAULT 0,
  attempt_count INTEGER NOT NULL DEFAULT 0,
  current_streak INTEGER NOT NULL DEFAULT 0,
  best_streak INTEGER NOT NULL DEFAULT 0,
  last_solved_date TEXT,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_puzzle_daily_puzzle ON puzzle_daily(puzzle_id);
CREATE INDEX IF NOT EXISTS idx_puzzle_attempts_puzzle_user ON puzzle_attempts(puzzle_id,user_id,created_at DESC);


CREATE TABLE IF NOT EXISTS game_invites (
  id TEXT PRIMARY KEY,
  from_user_id TEXT NOT NULL,
  to_user_id TEXT NOT NULL,
  room_code TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TEXT NOT NULL,
  FOREIGN KEY (from_user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (to_user_id) REFERENCES users(id) ON DELETE CASCADE,
  CHECK (from_user_id <> to_user_id),
  CHECK (status IN ('pending','accepted','declined','expired'))
);
CREATE INDEX IF NOT EXISTS idx_game_invites_to_status ON game_invites(to_user_id,status,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_game_invites_from_status ON game_invites(from_user_id,status,created_at DESC);


CREATE TABLE IF NOT EXISTS notifications (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  payload_json TEXT NOT NULL DEFAULT '{}',
  read_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_notifications_user_created ON notifications(user_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON notifications(user_id,read_at,created_at DESC);


CREATE TABLE IF NOT EXISTS game_results_notified (
  game_id TEXT PRIMARY KEY,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS rematch_requests (
  id TEXT PRIMARY KEY,
  game_id TEXT NOT NULL,
  from_user_id TEXT NOT NULL,
  to_user_id TEXT NOT NULL,
  room_code TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TEXT NOT NULL,
  FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
  FOREIGN KEY (from_user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (to_user_id) REFERENCES users(id) ON DELETE CASCADE,
  CHECK (from_user_id <> to_user_id),
  CHECK (status IN ('pending','accepted','declined','expired'))
);
CREATE INDEX IF NOT EXISTS idx_rematch_to_status ON rematch_requests(to_user_id,status,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_rematch_from_status ON rematch_requests(from_user_id,status,created_at DESC);

CREATE TABLE IF NOT EXISTS push_subscriptions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  endpoint TEXT NOT NULL UNIQUE,
  p256dh TEXT NOT NULL,
  auth TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_push_subscriptions_user ON push_subscriptions(user_id);

CREATE TABLE IF NOT EXISTS notification_preferences (
  user_id TEXT PRIMARY KEY,
  friend_request INTEGER NOT NULL DEFAULT 1,
  friend_accepted INTEGER NOT NULL DEFAULT 1,
  friend_declined INTEGER NOT NULL DEFAULT 1,
  game_invite INTEGER NOT NULL DEFAULT 1,
  game_result INTEGER NOT NULL DEFAULT 1,
  rematch_request INTEGER NOT NULL DEFAULT 1,
  rematch_accepted INTEGER NOT NULL DEFAULT 1,
  rematch_declined INTEGER NOT NULL DEFAULT 1,
  tournament_update INTEGER NOT NULL DEFAULT 1,
  push_enabled INTEGER NOT NULL DEFAULT 1,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS rating_history (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  game_id TEXT NOT NULL,
  old_rating INTEGER NOT NULL,
  new_rating INTEGER NOT NULL,
  delta INTEGER NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_rating_history_user_created ON rating_history(user_id,created_at DESC);


-- V34 seasonal competitive snapshots
CREATE TABLE IF NOT EXISTS season_player_stats (
  season_id TEXT NOT NULL, user_id TEXT NOT NULL, games INTEGER NOT NULL DEFAULT 0, wins INTEGER NOT NULL DEFAULT 0, draws INTEGER NOT NULL DEFAULT 0, losses INTEGER NOT NULL DEFAULT 0, start_rating INTEGER NOT NULL DEFAULT 1200, current_rating INTEGER NOT NULL DEFAULT 1200, peak_rating INTEGER NOT NULL DEFAULT 1200, rating_delta INTEGER NOT NULL DEFAULT 0, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (season_id,user_id), FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_season_stats_rank ON season_player_stats(season_id,current_rating DESC,rating_delta DESC,games DESC);
CREATE INDEX IF NOT EXISTS idx_season_stats_user ON season_player_stats(user_id,season_id);

-- V35 season lifecycle and idempotent result ledger
CREATE TABLE IF NOT EXISTS seasons (id TEXT PRIMARY KEY, label TEXT NOT NULL, starts_at TEXT NOT NULL, ends_at TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'active', finalized_at TEXT);
CREATE TABLE IF NOT EXISTS season_game_results (season_id TEXT NOT NULL, game_id TEXT NOT NULL, user_id TEXT NOT NULL, result TEXT NOT NULL, rating_before INTEGER NOT NULL, rating_after INTEGER NOT NULL, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (season_id,game_id,user_id));
CREATE TABLE IF NOT EXISTS season_rewards (season_id TEXT NOT NULL, user_id TEXT NOT NULL, rank INTEGER NOT NULL, tier TEXT NOT NULL, reward_key TEXT NOT NULL, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (season_id,user_id));
CREATE INDEX IF NOT EXISTS idx_season_games_user ON season_game_results(season_id,user_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_season_rewards_rank ON season_rewards(season_id,rank);

CREATE INDEX IF NOT EXISTS idx_seasons_status_ends ON seasons(status,ends_at);
CREATE INDEX IF NOT EXISTS idx_season_rewards_user ON season_rewards(user_id,created_at DESC);


-- V37 matchmaking queue
CREATE TABLE IF NOT EXISTS matchmaking_queue (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  rating INTEGER NOT NULL,
  time_control TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'waiting',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  matched_at TEXT,
  room_code TEXT,
  opponent_user_id TEXT,
  opponent_rating INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CHECK (status IN ('waiting','matched','cancelled','expired'))
);
CREATE INDEX IF NOT EXISTS idx_matchmaking_waiting ON matchmaking_queue(status,time_control,created_at);
CREATE INDEX IF NOT EXISTS idx_matchmaking_user_status ON matchmaking_queue(user_id,status,created_at DESC);

-- V38 live arena tournaments
CREATE TABLE IF NOT EXISTS arena_events (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  time_control TEXT NOT NULL,
  starts_at TEXT NOT NULL,
  ends_at TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (status IN ('active','finished'))
);
CREATE TABLE IF NOT EXISTS arena_participants (
  arena_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  joined_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  left_at TEXT,
  PRIMARY KEY (arena_id,user_id),
  FOREIGN KEY (arena_id) REFERENCES arena_events(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_arena_events_active ON arena_events(status,ends_at,time_control);
CREATE INDEX IF NOT EXISTS idx_arena_participants_user ON arena_participants(user_id,joined_at DESC);
CREATE INDEX IF NOT EXISTS idx_arena_participants_arena ON arena_participants(arena_id,joined_at);


-- V39 arena rewards and badges
CREATE TABLE IF NOT EXISTS arena_rewards (
  id TEXT PRIMARY KEY,
  arena_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  rank INTEGER NOT NULL,
  reward_key TEXT NOT NULL,
  points INTEGER NOT NULL DEFAULT 0,
  games INTEGER NOT NULL DEFAULT 0,
  wins INTEGER NOT NULL DEFAULT 0,
  draws INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(arena_id,user_id),
  FOREIGN KEY (arena_id) REFERENCES arena_events(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_arena_rewards_user_created ON arena_rewards(user_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_arena_rewards_arena_rank ON arena_rewards(arena_id,rank);


-- V41 anti-abuse + daily/weekly cup
CREATE TABLE IF NOT EXISTS arena_join_log (
  id TEXT PRIMARY KEY,
  arena_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  action TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (action IN ('join','leave')),
  FOREIGN KEY (arena_id) REFERENCES arena_events(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_arena_join_log_user_created ON arena_join_log(user_id,created_at DESC);

CREATE TABLE IF NOT EXISTS cup_events (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  kind TEXT NOT NULL,
  starts_at TEXT NOT NULL,
  ends_at TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (kind IN ('daily','weekly')),
  CHECK (status IN ('active','finished'))
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_cup_events_kind_start ON cup_events(kind,starts_at);
CREATE INDEX IF NOT EXISTS idx_cup_events_status_ends ON cup_events(status,ends_at);

CREATE TABLE IF NOT EXISTS cup_participants (
  cup_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  joined_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  left_at TEXT,
  PRIMARY KEY (cup_id,user_id),
  FOREIGN KEY (cup_id) REFERENCES cup_events(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_cup_participants_user ON cup_participants(user_id,joined_at DESC);
CREATE INDEX IF NOT EXISTS idx_cup_participants_cup ON cup_participants(cup_id,joined_at);

CREATE TABLE IF NOT EXISTS cup_rewards (
  id TEXT PRIMARY KEY,
  cup_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  rank INTEGER NOT NULL,
  reward_key TEXT NOT NULL,
  points INTEGER NOT NULL DEFAULT 0,
  games INTEGER NOT NULL DEFAULT 0,
  wins INTEGER NOT NULL DEFAULT 0,
  draws INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(cup_id,user_id),
  FOREIGN KEY (cup_id) REFERENCES cup_events(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_cup_rewards_user_created ON cup_rewards(user_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_cup_rewards_cup_rank ON cup_rewards(cup_id,rank);


-- V42 tournament brackets + spectator mode
-- V42 tournament brackets + spectator mode
CREATE TABLE IF NOT EXISTS tournaments (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  time_control TEXT NOT NULL,
  max_players INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'registration',
  created_by TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  starts_at TEXT,
  ends_at TEXT,
  tiebreak_mode TEXT NOT NULL DEFAULT 'seed',
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE,
  CHECK (max_players IN (4,8)),
  CHECK (status IN ('registration','active','finished','cancelled')),
  CHECK (tiebreak_mode IN ('seed','replay'))
);
CREATE INDEX IF NOT EXISTS idx_tournaments_status_created ON tournaments(status,created_at DESC);
CREATE TABLE IF NOT EXISTS tournament_players (
  tournament_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  seed INTEGER,
  rating_at_entry INTEGER,
  joined_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  eliminated_at TEXT,
  PRIMARY KEY (tournament_id,user_id),
  FOREIGN KEY (tournament_id) REFERENCES tournaments(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_tournament_players_tournament ON tournament_players(tournament_id,seed);
CREATE TABLE IF NOT EXISTS tournament_matches (
  id TEXT PRIMARY KEY,
  tournament_id TEXT NOT NULL,
  round INTEGER NOT NULL,
  match_no INTEGER NOT NULL,
  player1_id TEXT,
  player2_id TEXT,
  room_code TEXT NOT NULL UNIQUE,
  game_id TEXT,
  tiebreak_game_id TEXT,
  tiebreak_room_code TEXT UNIQUE,
  winner_id TEXT,
  tie_break TEXT NOT NULL DEFAULT 'none',
  winner_reason TEXT NOT NULL DEFAULT 'game_result',
  status TEXT NOT NULL DEFAULT 'ready',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (tournament_id) REFERENCES tournaments(id) ON DELETE CASCADE,
  FOREIGN KEY (player1_id) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (player2_id) REFERENCES users(id) ON DELETE SET NULL,
  CHECK (status IN ('ready','live','finished','bye')),
  UNIQUE(tournament_id,round,match_no)
);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_tournament ON tournament_matches(tournament_id,round,match_no);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_game ON tournament_matches(game_id);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_tiebreak_game ON tournament_matches(tiebreak_game_id);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_tiebreak_room ON tournament_matches(tiebreak_room_code);
CREATE TABLE IF NOT EXISTS tournament_rewards (
  id TEXT PRIMARY KEY,
  tournament_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  rank INTEGER NOT NULL,
  reward_key TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tournament_id,user_id),
  FOREIGN KEY (tournament_id) REFERENCES tournaments(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_tournament_rewards_user ON tournament_rewards(user_id,created_at DESC);

-- V45 supporting indexes are created by db/migrations/V45.sql
-- V46 analytics indexes are created by db/migrations/V46.sql

-- V47 tournament analytics entry-rating snapshot
-- Applied by db/migrations/V47.sql for existing deployments.

-- V49 public tournament shares
CREATE TABLE IF NOT EXISTS tournament_shares (
  id TEXT PRIMARY KEY,
  tournament_id TEXT NOT NULL,
  token_hash TEXT NOT NULL UNIQUE,
  created_by TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  revoked_at TEXT,
  FOREIGN KEY (tournament_id) REFERENCES tournaments(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tournament_shares_active ON tournament_shares(tournament_id) WHERE revoked_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_tournament_shares_token ON tournament_shares(token_hash);


-- ===== db/migrations/001_auth.sql =====
ALTER TABLE users ADD COLUMN password_hash TEXT NOT NULL DEFAULT '';
ALTER TABLE users ADD COLUMN password_salt TEXT NOT NULL DEFAULT '';


-- ===== db/migrations/002_analysis.sql =====
CREATE INDEX IF NOT EXISTS idx_analysis_game_engine ON analyses(game_id, engine, ply);


-- ===== db/migrations/V31.sql =====
-- ZATO Chess V31 migration
-- Adds persisted Stockfish centipawn loss so ACPL/accuracy can be calculated server-side.
ALTER TABLE analyses ADD COLUMN loss_cp INTEGER DEFAULT 0;


-- ===== db/migrations/V32.sql =====
-- ZATO Chess V32 production/readiness indexes
CREATE INDEX IF NOT EXISTS idx_games_finished_time_control ON games(status,time_control,ended_at DESC);
CREATE INDEX IF NOT EXISTS idx_games_white_finished ON games(white_user_id,status,ended_at DESC);
CREATE INDEX IF NOT EXISTS idx_games_black_finished ON games(black_user_id,status,ended_at DESC);
CREATE INDEX IF NOT EXISTS idx_analyses_game_loss ON analyses(game_id,loss_cp);
CREATE INDEX IF NOT EXISTS idx_rating_history_game_user ON rating_history(game_id,user_id);


-- ===== db/migrations/V33.sql =====
-- ZATO Chess V33: competitive season / rank-tier support.
-- Season stats are derived from existing games + rating_history, so no backfill is required.
CREATE INDEX IF NOT EXISTS idx_games_finished_ended ON games(status, ended_at DESC);
CREATE INDEX IF NOT EXISTS idx_rating_history_game_user ON rating_history(game_id, user_id);


-- ===== db/migrations/V34.sql =====
-- ZATO Chess V34: seasonal competitive snapshots
CREATE TABLE IF NOT EXISTS season_player_stats (
  season_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  games INTEGER NOT NULL DEFAULT 0,
  wins INTEGER NOT NULL DEFAULT 0,
  draws INTEGER NOT NULL DEFAULT 0,
  losses INTEGER NOT NULL DEFAULT 0,
  start_rating INTEGER NOT NULL DEFAULT 1200,
  current_rating INTEGER NOT NULL DEFAULT 1200,
  peak_rating INTEGER NOT NULL DEFAULT 1200,
  rating_delta INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (season_id,user_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_season_stats_rank ON season_player_stats(season_id,current_rating DESC,rating_delta DESC,games DESC);
CREATE INDEX IF NOT EXISTS idx_season_stats_user ON season_player_stats(user_id,season_id);


-- ===== db/migrations/V35.sql =====
-- V35: season lifecycle, idempotent backfill ledger, rewards
CREATE TABLE IF NOT EXISTS seasons (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  starts_at TEXT NOT NULL,
  ends_at TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active',
  finalized_at TEXT
);
CREATE TABLE IF NOT EXISTS season_game_results (
  season_id TEXT NOT NULL,
  game_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  result TEXT NOT NULL,
  rating_before INTEGER NOT NULL,
  rating_after INTEGER NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (season_id, game_id, user_id)
);
CREATE TABLE IF NOT EXISTS season_rewards (
  season_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  rank INTEGER NOT NULL,
  tier TEXT NOT NULL,
  reward_key TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (season_id, user_id)
);
CREATE INDEX IF NOT EXISTS idx_season_games_user ON season_game_results(season_id,user_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_season_rewards_rank ON season_rewards(season_id,rank);


-- ===== db/migrations/V36.sql =====
-- ZATO Chess V36
-- Season history/reward query indexes. Safe and idempotent.
CREATE INDEX IF NOT EXISTS idx_seasons_status_ends ON seasons(status,ends_at);
CREATE INDEX IF NOT EXISTS idx_season_rewards_user ON season_rewards(user_id,created_at DESC);


-- ===== db/migrations/V37.sql =====
-- V37: production smoke-test support + serialized matchmaking queue
CREATE TABLE IF NOT EXISTS matchmaking_queue (
  id TEXT PRIMARY KEY, user_id TEXT NOT NULL, rating INTEGER NOT NULL, time_control TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'waiting', created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, matched_at TEXT,
  room_code TEXT, opponent_user_id TEXT, opponent_rating INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CHECK (status IN ('waiting','matched','cancelled','expired'))
);
CREATE INDEX IF NOT EXISTS idx_matchmaking_waiting ON matchmaking_queue(status,time_control,created_at);
CREATE INDEX IF NOT EXISTS idx_matchmaking_user_status ON matchmaking_queue(user_id,status,created_at DESC);


-- ===== db/migrations/V38.sql =====
-- V38 arena live scoring
ALTER TABLE matchmaking_queue ADD COLUMN arena_id TEXT;
CREATE TABLE IF NOT EXISTS arena_events (id TEXT PRIMARY KEY,label TEXT NOT NULL,time_control TEXT NOT NULL,starts_at TEXT NOT NULL,ends_at TEXT NOT NULL,status TEXT NOT NULL DEFAULT 'active',created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,CHECK(status IN ('active','finished')));
CREATE TABLE IF NOT EXISTS arena_participants (arena_id TEXT NOT NULL,user_id TEXT NOT NULL,joined_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,left_at TEXT,PRIMARY KEY(arena_id,user_id),FOREIGN KEY(arena_id) REFERENCES arena_events(id) ON DELETE CASCADE,FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE);
CREATE INDEX IF NOT EXISTS idx_arena_events_active ON arena_events(status,ends_at,time_control);
CREATE INDEX IF NOT EXISTS idx_arena_participants_user ON arena_participants(user_id,joined_at DESC);
CREATE INDEX IF NOT EXISTS idx_arena_participants_arena ON arena_participants(arena_id,joined_at);
CREATE INDEX IF NOT EXISTS idx_matchmaking_arena ON matchmaking_queue(arena_id,status,time_control,created_at);


-- ===== db/migrations/V39.sql =====
-- ZATO Chess V39: Arena rewards and player metrics
CREATE TABLE IF NOT EXISTS arena_rewards (
  id TEXT PRIMARY KEY,
  arena_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  rank INTEGER NOT NULL,
  reward_key TEXT NOT NULL,
  points INTEGER NOT NULL DEFAULT 0,
  games INTEGER NOT NULL DEFAULT 0,
  wins INTEGER NOT NULL DEFAULT 0,
  draws INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(arena_id,user_id),
  FOREIGN KEY (arena_id) REFERENCES arena_events(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_arena_rewards_user_created ON arena_rewards(user_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_arena_rewards_arena_rank ON arena_rewards(arena_id,rank);


-- ===== db/migrations/V41.sql =====
-- V41 anti-abuse + daily/weekly cup
CREATE TABLE IF NOT EXISTS arena_join_log (
  id TEXT PRIMARY KEY,
  arena_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  action TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (action IN ('join','leave')),
  FOREIGN KEY (arena_id) REFERENCES arena_events(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_arena_join_log_user_created ON arena_join_log(user_id,created_at DESC);

CREATE TABLE IF NOT EXISTS cup_events (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  kind TEXT NOT NULL,
  starts_at TEXT NOT NULL,
  ends_at TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (kind IN ('daily','weekly')),
  CHECK (status IN ('active','finished'))
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_cup_events_kind_start ON cup_events(kind,starts_at);
CREATE INDEX IF NOT EXISTS idx_cup_events_status_ends ON cup_events(status,ends_at);

CREATE TABLE IF NOT EXISTS cup_participants (
  cup_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  joined_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  left_at TEXT,
  PRIMARY KEY (cup_id,user_id),
  FOREIGN KEY (cup_id) REFERENCES cup_events(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_cup_participants_user ON cup_participants(user_id,joined_at DESC);
CREATE INDEX IF NOT EXISTS idx_cup_participants_cup ON cup_participants(cup_id,joined_at);

CREATE TABLE IF NOT EXISTS cup_rewards (
  id TEXT PRIMARY KEY,
  cup_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  rank INTEGER NOT NULL,
  reward_key TEXT NOT NULL,
  points INTEGER NOT NULL DEFAULT 0,
  games INTEGER NOT NULL DEFAULT 0,
  wins INTEGER NOT NULL DEFAULT 0,
  draws INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(cup_id,user_id),
  FOREIGN KEY (cup_id) REFERENCES cup_events(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_cup_rewards_user_created ON cup_rewards(user_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_cup_rewards_cup_rank ON cup_rewards(cup_id,rank);


-- ===== db/migrations/V42.sql =====
-- V42 tournament brackets + spectator mode
CREATE TABLE IF NOT EXISTS tournaments (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  time_control TEXT NOT NULL,
  max_players INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'registration',
  created_by TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  starts_at TEXT,
  ends_at TEXT,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE,
  CHECK (max_players IN (4,8)),
  CHECK (status IN ('registration','active','finished','cancelled'))
);
CREATE INDEX IF NOT EXISTS idx_tournaments_status_created ON tournaments(status,created_at DESC);
CREATE TABLE IF NOT EXISTS tournament_players (
  tournament_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  seed INTEGER,
  joined_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  eliminated_at TEXT,
  PRIMARY KEY (tournament_id,user_id),
  FOREIGN KEY (tournament_id) REFERENCES tournaments(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_tournament_players_tournament ON tournament_players(tournament_id,seed);
CREATE TABLE IF NOT EXISTS tournament_matches (
  id TEXT PRIMARY KEY,
  tournament_id TEXT NOT NULL,
  round INTEGER NOT NULL,
  match_no INTEGER NOT NULL,
  player1_id TEXT,
  player2_id TEXT,
  room_code TEXT NOT NULL UNIQUE,
  game_id TEXT,
  winner_id TEXT,
  status TEXT NOT NULL DEFAULT 'ready',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (tournament_id) REFERENCES tournaments(id) ON DELETE CASCADE,
  FOREIGN KEY (player1_id) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (player2_id) REFERENCES users(id) ON DELETE SET NULL,
  CHECK (status IN ('ready','live','finished','bye')),
  UNIQUE(tournament_id,round,match_no)
);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_tournament ON tournament_matches(tournament_id,round,match_no);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_game ON tournament_matches(game_id);
CREATE TABLE IF NOT EXISTS tournament_rewards (
  id TEXT PRIMARY KEY,
  tournament_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  rank INTEGER NOT NULL,
  reward_key TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tournament_id,user_id),
  FOREIGN KEY (tournament_id) REFERENCES tournaments(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_tournament_rewards_user ON tournament_rewards(user_id,created_at DESC);


-- ===== db/migrations/V43.sql =====
-- V43 tournament hardening: explicit draw tie-break + tournament notifications
ALTER TABLE tournament_matches ADD COLUMN tie_break TEXT NOT NULL DEFAULT 'none';
ALTER TABLE tournament_matches ADD COLUMN winner_reason TEXT NOT NULL DEFAULT 'game_result';
ALTER TABLE notification_preferences ADD COLUMN tournament_update INTEGER NOT NULL DEFAULT 1;
CREATE INDEX IF NOT EXISTS idx_tournament_matches_status ON tournament_matches(tournament_id,status,round,match_no);


-- ===== db/migrations/V44.sql =====
-- V44 tournament quality expansion: replay tie-breaks + history
ALTER TABLE tournaments ADD COLUMN tiebreak_mode TEXT NOT NULL DEFAULT 'seed';
ALTER TABLE tournament_matches ADD COLUMN tiebreak_game_id TEXT;
ALTER TABLE tournament_matches ADD COLUMN tiebreak_room_code TEXT;
CREATE INDEX IF NOT EXISTS idx_tournament_matches_tiebreak_game ON tournament_matches(tiebreak_game_id);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_tiebreak_room ON tournament_matches(tiebreak_room_code);
CREATE INDEX IF NOT EXISTS idx_tournaments_finished_ends ON tournaments(status,ends_at DESC);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tournament_matches_tiebreak_room_unique ON tournament_matches(tiebreak_room_code) WHERE tiebreak_room_code IS NOT NULL;


-- ===== db/migrations/V45.sql =====
-- V45 tournament rating isolation + standings indexes
CREATE INDEX IF NOT EXISTS idx_tournament_matches_tournament_winner ON tournament_matches(tournament_id,winner_id,status);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_players ON tournament_matches(tournament_id,player1_id,player2_id,status);


-- ===== db/migrations/V46.sql =====
-- V46: tournament analytics/profile/history query indexes
CREATE INDEX IF NOT EXISTS idx_tournament_players_user ON tournament_players(user_id,tournament_id);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_winner ON tournament_matches(winner_id,tournament_id);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_players ON tournament_matches(tournament_id,player1_id,player2_id,status);


-- ===== db/migrations/V47.sql =====
-- V47: tournament round analytics, entry-rating snapshots, replay/review history indexes
ALTER TABLE tournament_players ADD COLUMN rating_at_entry INTEGER;
UPDATE tournament_players
SET rating_at_entry = COALESCE(rating_at_entry, (SELECT rating FROM users WHERE users.id=tournament_players.user_id));

CREATE INDEX IF NOT EXISTS idx_tournament_players_rating ON tournament_players(tournament_id,rating_at_entry);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_round_status ON tournament_matches(tournament_id,round,status);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_replay_games ON tournament_matches(tiebreak_game_id,game_id);


-- ===== db/migrations/V49.sql =====
-- V49 public tournament shares
CREATE TABLE IF NOT EXISTS tournament_shares (
  id TEXT PRIMARY KEY,
  tournament_id TEXT NOT NULL,
  token_hash TEXT NOT NULL UNIQUE,
  created_by TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  revoked_at TEXT,
  FOREIGN KEY (tournament_id) REFERENCES tournaments(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tournament_shares_active ON tournament_shares(tournament_id) WHERE revoked_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_tournament_shares_token ON tournament_shares(token_hash);


-- ===== db/migrations/V50.sql =====
-- V50 public share analytics
ALTER TABLE tournament_shares ADD COLUMN views_count INTEGER NOT NULL DEFAULT 0;
ALTER TABLE tournament_shares ADD COLUMN last_viewed_at TEXT;
CREATE INDEX IF NOT EXISTS idx_tournament_shares_views ON tournament_shares(views_count DESC);


-- ===== db/migrations/V51.sql =====
-- V51 share security + privacy controls
ALTER TABLE tournament_shares ADD COLUMN expires_at TEXT;
ALTER TABLE tournament_shares ADD COLUMN visibility TEXT NOT NULL DEFAULT 'public';
UPDATE tournament_shares SET expires_at=datetime(created_at,'+30 days') WHERE expires_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_tournament_shares_active ON tournament_shares(tournament_id,revoked_at,expires_at);


-- ===== db/migrations/V52.sql =====
-- V52 public share rate limiting + privacy-safe daily analytics
CREATE TABLE IF NOT EXISTS tournament_share_rate_limits (
  token_hash TEXT NOT NULL,
  window_start TEXT NOT NULL,
  hits INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (token_hash, window_start)
);
CREATE TABLE IF NOT EXISTS tournament_share_daily (
  share_id TEXT NOT NULL,
  day TEXT NOT NULL,
  views INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (share_id, day)
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_daily_share_day ON tournament_share_daily(share_id, day DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_rate_window ON tournament_share_rate_limits(window_start);


-- ===== db/migrations/V54.sql =====
-- V54 public share abuse telemetry (aggregate, privacy-safe)
CREATE TABLE IF NOT EXISTS tournament_share_abuse_windows (
  token_hash TEXT NOT NULL,
  window_start TEXT NOT NULL,
  allowed_hits INTEGER NOT NULL DEFAULT 0,
  blocked_hits INTEGER NOT NULL DEFAULT 0,
  last_blocked_at TEXT,
  PRIMARY KEY (token_hash, window_start)
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_abuse_window ON tournament_share_abuse_windows(window_start);
CREATE INDEX IF NOT EXISTS idx_tournament_share_abuse_token ON tournament_share_abuse_windows(token_hash, window_start DESC);


-- ===== db/migrations/V56.sql =====
-- V56 public share audit trail
CREATE TABLE IF NOT EXISTS tournament_share_audit (
  id TEXT PRIMARY KEY,
  tournament_id TEXT NOT NULL,
  share_id TEXT NOT NULL,
  event TEXT NOT NULL,
  metadata TEXT NOT NULL DEFAULT '{}',
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_audit_tournament ON tournament_share_audit(tournament_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_audit_share ON tournament_share_audit(share_id, created_at DESC);


-- ===== db/migrations/V57.sql =====
-- V57 public share audit retention and daily aggregation
CREATE TABLE IF NOT EXISTS tournament_share_audit_daily (
  day TEXT NOT NULL,
  tournament_id TEXT NOT NULL,
  share_id TEXT NOT NULL,
  event TEXT NOT NULL,
  count INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY(day, tournament_id, share_id, event)
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_audit_daily_tournament ON tournament_share_audit_daily(tournament_id, day DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_audit_daily_share ON tournament_share_audit_daily(share_id, day DESC);


-- ===== db/migrations/V58.sql =====
-- V58 share health dashboard indexes and alert-ready retention support
CREATE INDEX IF NOT EXISTS idx_tournament_share_audit_daily_event_day ON tournament_share_audit_daily(event, day DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_audit_tournament_created ON tournament_share_audit(tournament_id, created_at DESC);


-- ===== db/migrations/V59.sql =====
-- V59 cache-aware analytics + alert history + health export
CREATE TABLE IF NOT EXISTS tournament_share_cache_daily (
  day TEXT NOT NULL,
  tournament_id TEXT NOT NULL,
  share_id TEXT NOT NULL,
  route TEXT NOT NULL,
  origin_hits INTEGER NOT NULL DEFAULT 0,
  conditional_hits INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY(day, share_id, route)
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_cache_daily_tournament_day ON tournament_share_cache_daily(tournament_id, day DESC);
CREATE TABLE IF NOT EXISTS tournament_share_alert_history (
  id TEXT PRIMARY KEY,
  tournament_id TEXT NOT NULL,
  share_id TEXT NOT NULL,
  alert TEXT NOT NULL,
  first_seen_at TEXT NOT NULL,
  last_seen_at TEXT NOT NULL,
  occurrences INTEGER NOT NULL DEFAULT 1
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tournament_share_alert_unique ON tournament_share_alert_history(share_id, alert);
CREATE INDEX IF NOT EXISTS idx_tournament_share_alert_tournament ON tournament_share_alert_history(tournament_id, last_seen_at DESC);


-- ===== db/migrations/V60.sql =====
-- V60 export integrity + cache aggregation + alert acknowledgement
CREATE TABLE IF NOT EXISTS tournament_share_alert_ack (
  share_id TEXT NOT NULL,
  alert TEXT NOT NULL,
  acknowledged_at TEXT NOT NULL,
  acknowledged_by TEXT NOT NULL,
  PRIMARY KEY(share_id, alert)
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_alert_ack_share ON tournament_share_alert_ack(share_id, acknowledged_at DESC);


-- ===== db/migrations/V61.sql =====
-- V61 export verification + alert lifecycle + maintenance diagnostics
CREATE TABLE IF NOT EXISTS tournament_share_alert_ack_v61 (
  share_id TEXT NOT NULL,
  alert TEXT NOT NULL,
  acknowledged_at TEXT NOT NULL,
  acknowledged_by TEXT NOT NULL,
  acknowledged_occurrences INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY(share_id, alert)
);
INSERT OR IGNORE INTO tournament_share_alert_ack_v61(share_id,alert,acknowledged_at,acknowledged_by,acknowledged_occurrences)
SELECT share_id,alert,acknowledged_at,acknowledged_by,0 FROM tournament_share_alert_ack;
DROP INDEX IF EXISTS idx_tournament_share_alert_ack_share;
DROP TABLE IF EXISTS tournament_share_alert_ack;
ALTER TABLE tournament_share_alert_ack_v61 RENAME TO tournament_share_alert_ack;
CREATE INDEX IF NOT EXISTS idx_tournament_share_alert_ack_share ON tournament_share_alert_ack(share_id, acknowledged_at DESC);

CREATE TABLE IF NOT EXISTS tournament_share_maintenance_runs (
  id TEXT PRIMARY KEY,
  ran_at TEXT NOT NULL,
  audit_aggregated INTEGER NOT NULL DEFAULT 0,
  audit_deleted INTEGER NOT NULL DEFAULT 0,
  cache_deleted INTEGER NOT NULL DEFAULT 0,
  alerts_deleted INTEGER NOT NULL DEFAULT 0,
  rate_limits_deleted INTEGER NOT NULL DEFAULT 0,
  abuse_windows_deleted INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_maintenance_runs_ran_at ON tournament_share_maintenance_runs(ran_at DESC);


-- ===== db/migrations/V62.sql =====
-- V62 export verification, acknowledgement audit, maintenance error telemetry, cache route comparison
CREATE TABLE IF NOT EXISTS tournament_share_alert_ack_audit (
  id TEXT PRIMARY KEY, share_id TEXT NOT NULL, alert TEXT NOT NULL, action TEXT NOT NULL,
  occurrences INTEGER NOT NULL DEFAULT 0, acknowledged_by TEXT, created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_alert_ack_audit_share_created ON tournament_share_alert_ack_audit(share_id,created_at DESC);

CREATE TABLE IF NOT EXISTS tournament_share_maintenance_errors (
  id TEXT PRIMARY KEY, run_id TEXT NOT NULL, stage TEXT NOT NULL, message TEXT NOT NULL, created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_maintenance_errors_run ON tournament_share_maintenance_errors(run_id,created_at DESC);

CREATE TABLE IF NOT EXISTS tournament_share_maintenance_run_meta (
  run_id TEXT PRIMARY KEY, status TEXT NOT NULL DEFAULT 'ok', error_count INTEGER NOT NULL DEFAULT 0
);


-- ===== db/migrations/V63.sql =====
-- V63 export signature metadata, alert audit filtering, maintenance replay diagnostics
CREATE TABLE IF NOT EXISTS tournament_share_export_keys (
  key_id TEXT PRIMARY KEY, algorithm TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'active', created_at TEXT NOT NULL, retired_at TEXT
);
CREATE TABLE IF NOT EXISTS tournament_share_maintenance_replays (
  id TEXT PRIMARY KEY, tournament_id TEXT NOT NULL, created_at TEXT NOT NULL, status TEXT NOT NULL, payload TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_maintenance_replays_tournament_created ON tournament_share_maintenance_replays(tournament_id,created_at DESC);


-- ===== db/migrations/V64.sql =====
-- V64 signed export verification, key lifecycle, maintenance replay snapshots
CREATE TABLE IF NOT EXISTS tournament_share_export_key_events (
  id TEXT PRIMARY KEY, key_id TEXT NOT NULL, action TEXT NOT NULL, created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_export_key_events_key_created ON tournament_share_export_key_events(key_id,created_at DESC);


-- ===== db/migrations/V65.sql =====
-- V65 signature rotation harness, replay diff persistence, route contract runs
CREATE TABLE IF NOT EXISTS tournament_share_maintenance_replay_diffs (
  id TEXT PRIMARY KEY,
  replay_id TEXT NOT NULL,
  previous_replay_id TEXT,
  created_at TEXT NOT NULL,
  diff_json TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_maintenance_replay_diffs_replay_created ON tournament_share_maintenance_replay_diffs(replay_id,created_at DESC);
CREATE TABLE IF NOT EXISTS tournament_share_route_contract_runs (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  route TEXT NOT NULL,
  method TEXT NOT NULL,
  expected_status INTEGER NOT NULL,
  expected_cache TEXT,
  observed_status INTEGER,
  observed_cache TEXT,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_route_contract_runs_tournament_created ON tournament_share_route_contract_runs(tournament_id,created_at DESC);


-- ===== db/migrations/V66.sql =====
-- V66 route/cache replay fixtures and key rotation verification runs
CREATE TABLE IF NOT EXISTS tournament_share_contract_replays (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  route TEXT NOT NULL,
  sequence_json TEXT NOT NULL,
  passed INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_key_rotation_runs (
  id TEXT PRIMARY KEY,
  previous_key_id TEXT,
  active_key_id TEXT NOT NULL,
  event_count INTEGER NOT NULL DEFAULT 0,
  passed INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_contract_replays_created ON tournament_share_contract_replays(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_key_rotation_runs_created ON tournament_share_key_rotation_runs(created_at DESC);


-- ===== db/migrations/V67.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_contract_replay_evidence (
  id TEXT PRIMARY KEY,
  replay_id TEXT NOT NULL,
  route TEXT NOT NULL,
  status_code INTEGER NOT NULL,
  cache_marker TEXT,
  etag TEXT,
  body_hash TEXT,
  error_code TEXT,
  detail TEXT,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_key_rotation_audit (
  id TEXT PRIMARY KEY,
  run_id TEXT,
  previous_key_id TEXT,
  active_key_id TEXT NOT NULL,
  action TEXT NOT NULL,
  passed INTEGER NOT NULL DEFAULT 0,
  detail TEXT,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_maintenance_replay_runs (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  source_replay_id TEXT,
  replay_hash TEXT NOT NULL,
  status TEXT NOT NULL,
  deterministic INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_contract_evidence_replay ON tournament_share_contract_replay_evidence(replay_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_key_rotation_audit_created ON tournament_share_key_rotation_audit(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_maintenance_replay_runs_tournament ON tournament_share_maintenance_replay_runs(tournament_id,created_at DESC);


-- ===== db/migrations/V68.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_contract_replay_summary (
  replay_id TEXT PRIMARY KEY,
  tournament_id TEXT,
  total_routes INTEGER NOT NULL DEFAULT 0,
  passed_routes INTEGER NOT NULL DEFAULT 0,
  failed_routes INTEGER NOT NULL DEFAULT 0,
  conditional_hits INTEGER NOT NULL DEFAULT 0,
  origin_hits INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_key_audit_chain (
  id TEXT PRIMARY KEY,
  audit_id TEXT NOT NULL,
  previous_hash TEXT,
  entry_hash TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_contract_summary_tournament ON tournament_share_contract_replay_summary(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_key_audit_chain_audit ON tournament_share_key_audit_chain(audit_id,created_at DESC);


-- ===== db/migrations/V69.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_evidence_retention (
  scope TEXT PRIMARY KEY,
  evidence_days INTEGER NOT NULL DEFAULT 90,
  summary_days INTEGER NOT NULL DEFAULT 180,
  key_chain_days INTEGER NOT NULL DEFAULT 365,
  updated_at TEXT NOT NULL
);
INSERT OR IGNORE INTO tournament_share_evidence_retention(scope,evidence_days,summary_days,key_chain_days,updated_at)
VALUES ('public-share',90,180,365,datetime('now'));
CREATE INDEX IF NOT EXISTS idx_tournament_share_evidence_retention_updated ON tournament_share_evidence_retention(updated_at DESC);


-- ===== db/migrations/V70.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_verification_history (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  replay_id TEXT,
  verification_type TEXT NOT NULL,
  valid INTEGER NOT NULL DEFAULT 0,
  failure_count INTEGER NOT NULL DEFAULT 0,
  detail TEXT,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_retention_runs (
  id TEXT PRIMARY KEY,
  ran_at TEXT NOT NULL,
  status TEXT NOT NULL,
  evidence_deleted INTEGER NOT NULL DEFAULT 0,
  summary_deleted INTEGER NOT NULL DEFAULT 0,
  key_chain_deleted INTEGER NOT NULL DEFAULT 0,
  verification_deleted INTEGER NOT NULL DEFAULT 0,
  error_count INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_history_tournament ON tournament_share_verification_history(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_history_replay ON tournament_share_verification_history(replay_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_retention_runs_ran_at ON tournament_share_retention_runs(ran_at DESC);


-- ===== db/migrations/V71.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_verification_incidents (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  replay_id TEXT,
  verification_type TEXT NOT NULL,
  fingerprint TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'open',
  first_seen_at TEXT NOT NULL,
  last_seen_at TEXT NOT NULL,
  occurrences INTEGER NOT NULL DEFAULT 1,
  acknowledged_at TEXT,
  resolved_at TEXT,
  detail TEXT
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_incidents_tournament ON tournament_share_verification_incidents(tournament_id,last_seen_at DESC);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tournament_share_verification_incidents_fingerprint ON tournament_share_verification_incidents(fingerprint);


-- ===== db/migrations/V72.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_verification_incident_audit (
  id TEXT PRIMARY KEY,
  incident_id TEXT NOT NULL,
  tournament_id TEXT,
  action TEXT NOT NULL,
  previous_status TEXT,
  next_status TEXT NOT NULL,
  occurrences INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  detail TEXT
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_incident_audit_incident ON tournament_share_verification_incident_audit(incident_id,created_at DESC);

CREATE TABLE IF NOT EXISTS tournament_share_retention_errors (
  id TEXT PRIMARY KEY,
  run_id TEXT NOT NULL,
  stage TEXT NOT NULL,
  message TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_retention_errors_run ON tournament_share_retention_errors(run_id,created_at DESC);

CREATE TABLE IF NOT EXISTS tournament_share_replay_comparisons (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  left_replay_id TEXT NOT NULL,
  right_replay_id TEXT NOT NULL,
  route_count INTEGER NOT NULL DEFAULT 0,
  changed_routes INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  payload TEXT NOT NULL,
  integrity_sha256 TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_replay_comparisons_tournament ON tournament_share_replay_comparisons(tournament_id,created_at DESC);


-- ===== db/migrations/V73.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_contract_matrix_snapshots (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  replay_id TEXT NOT NULL,
  route_count INTEGER NOT NULL DEFAULT 0,
  passed_routes INTEGER NOT NULL DEFAULT 0,
  failed_routes INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  payload TEXT NOT NULL,
  integrity_sha256 TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_contract_matrix_snapshots_tournament ON tournament_share_contract_matrix_snapshots(tournament_id,created_at DESC);
CREATE TABLE IF NOT EXISTS tournament_share_retention_error_actions (
  id TEXT PRIMARY KEY,
  error_id TEXT NOT NULL,
  run_id TEXT NOT NULL,
  action TEXT NOT NULL,
  previous_status TEXT,
  next_status TEXT NOT NULL,
  created_at TEXT NOT NULL,
  detail TEXT
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_retention_error_actions_error ON tournament_share_retention_error_actions(error_id,created_at DESC);


-- ===== db/migrations/V74.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_replay_bundle_signatures (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  bundle_type TEXT NOT NULL,
  algorithm TEXT NOT NULL,
  key_id TEXT,
  signature TEXT NOT NULL,
  payload_sha256 TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_replay_bundle_signatures_tournament ON tournament_share_replay_bundle_signatures(tournament_id,created_at DESC);
CREATE TABLE IF NOT EXISTS tournament_share_matrix_diffs (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  left_replay_id TEXT NOT NULL,
  right_replay_id TEXT NOT NULL,
  changed_routes INTEGER NOT NULL DEFAULT 0,
  payload TEXT NOT NULL,
  integrity_sha256 TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_matrix_diffs_tournament ON tournament_share_matrix_diffs(tournament_id,created_at DESC);
CREATE TABLE IF NOT EXISTS tournament_share_retention_action_audit (
  id TEXT PRIMARY KEY,
  action_id TEXT NOT NULL,
  error_id TEXT NOT NULL,
  action TEXT NOT NULL,
  previous_status TEXT,
  next_status TEXT NOT NULL,
  entry_hash TEXT NOT NULL,
  previous_hash TEXT,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_retention_action_audit_error ON tournament_share_retention_action_audit(error_id,created_at DESC);
CREATE TABLE IF NOT EXISTS tournament_share_contract_cleanup_replays (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  candidate_evidence INTEGER NOT NULL DEFAULT 0,
  candidate_snapshots INTEGER NOT NULL DEFAULT 0,
  candidate_diffs INTEGER NOT NULL DEFAULT 0,
  candidate_signatures INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);


-- ===== db/migrations/V75.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_replay_bundle_verifications (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  bundle_sha256 TEXT NOT NULL,
  signature_valid INTEGER NOT NULL DEFAULT 0,
  integrity_valid INTEGER NOT NULL DEFAULT 0,
  reason TEXT,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_bundle_verifications_tournament ON tournament_share_replay_bundle_verifications(tournament_id,created_at DESC);
CREATE TABLE IF NOT EXISTS tournament_share_cleanup_replay_history (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  replay_id TEXT NOT NULL,
  candidate_evidence INTEGER NOT NULL DEFAULT 0,
  candidate_snapshots INTEGER NOT NULL DEFAULT 0,
  candidate_diffs INTEGER NOT NULL DEFAULT 0,
  candidate_signatures INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  integrity_sha256 TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_cleanup_replay_history_tournament ON tournament_share_cleanup_replay_history(tournament_id,created_at DESC);
CREATE TABLE IF NOT EXISTS tournament_share_retention_policy_checks (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  policy_version TEXT NOT NULL,
  consistent INTEGER NOT NULL DEFAULT 0,
  policies TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_retention_policy_checks_tournament ON tournament_share_retention_policy_checks(tournament_id,created_at DESC);


-- ===== db/migrations/V76.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_replay_bundle_verification_audit (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  bundle_sha256 TEXT NOT NULL,
  key_id TEXT,
  algorithm TEXT NOT NULL,
  integrity_valid INTEGER NOT NULL DEFAULT 0,
  signature_valid INTEGER NOT NULL DEFAULT 0,
  key_status TEXT,
  reason TEXT,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_retention_policy_check_history (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  policy_version TEXT NOT NULL,
  consistent INTEGER NOT NULL DEFAULT 0,
  policies TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_cleanup_replay_exports (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  replay_id TEXT NOT NULL,
  payload TEXT NOT NULL,
  integrity_sha256 TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_bundle_verification_audit_tournament ON tournament_share_replay_bundle_verification_audit(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_policy_check_history_tournament ON tournament_share_retention_policy_check_history(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_cleanup_replay_exports_tournament ON tournament_share_cleanup_replay_exports(tournament_id,created_at DESC);


-- ===== db/migrations/V77.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_key_chain_verification_history (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  audit_id TEXT,
  valid INTEGER NOT NULL DEFAULT 0,
  entries_checked INTEGER NOT NULL DEFAULT 0,
  failure_index INTEGER,
  reason TEXT,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_contract_snapshot_diffs (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  left_snapshot_id TEXT NOT NULL,
  right_snapshot_id TEXT NOT NULL,
  changed_routes INTEGER NOT NULL DEFAULT 0,
  added_routes INTEGER NOT NULL DEFAULT 0,
  removed_routes INTEGER NOT NULL DEFAULT 0,
  payload TEXT NOT NULL,
  integrity_sha256 TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_policy_drift_history (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  policy_version TEXT NOT NULL,
  drifted INTEGER NOT NULL DEFAULT 0,
  detail TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_key_chain_verification_tournament ON tournament_share_key_chain_verification_history(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_snapshot_diffs_tournament ON tournament_share_contract_snapshot_diffs(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_policy_drift_tournament ON tournament_share_policy_drift_history(tournament_id,created_at DESC);


-- ===== db/migrations/V78.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_verification_exports (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  export_version TEXT NOT NULL,
  row_count INTEGER NOT NULL DEFAULT 0,
  integrity_sha256 TEXT NOT NULL,
  signature TEXT,
  key_id TEXT,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_policy_drift_alerts (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  alert_type TEXT NOT NULL,
  threshold INTEGER NOT NULL DEFAULT 0,
  observed INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'open',
  created_at TEXT NOT NULL,
  resolved_at TEXT
);
CREATE TABLE IF NOT EXISTS tournament_share_verification_replays (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  status TEXT NOT NULL,
  checks INTEGER NOT NULL DEFAULT 0,
  failures INTEGER NOT NULL DEFAULT 0,
  integrity_sha256 TEXT,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_exports_tournament ON tournament_share_verification_exports(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_policy_drift_alerts_tournament ON tournament_share_policy_drift_alerts(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_replays_tournament ON tournament_share_verification_replays(tournament_id,created_at DESC);


-- ===== db/migrations/V79.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_verification_export_checks (
  id TEXT PRIMARY KEY, tournament_id TEXT, export_version TEXT NOT NULL, integrity_valid INTEGER NOT NULL DEFAULT 0, signature_valid INTEGER NOT NULL DEFAULT 0, reason TEXT, created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_policy_drift_ack (
  id TEXT PRIMARY KEY, tournament_id TEXT, alert_id TEXT NOT NULL, action TEXT NOT NULL, created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_replay_history_checks (
  id TEXT PRIMARY KEY, tournament_id TEXT, replay_id TEXT NOT NULL, history_id TEXT, integrity_valid INTEGER NOT NULL DEFAULT 0, reason TEXT, created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_v78_cleanup_replays (
  id TEXT PRIMARY KEY, tournament_id TEXT, candidate_exports INTEGER NOT NULL DEFAULT 0, candidate_alerts INTEGER NOT NULL DEFAULT 0, candidate_replays INTEGER NOT NULL DEFAULT 0, integrity_sha256 TEXT, created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_export_checks_tournament ON tournament_share_verification_export_checks(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_policy_drift_ack_tournament ON tournament_share_policy_drift_ack(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_replay_history_checks_tournament ON tournament_share_replay_history_checks(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_v78_cleanup_replays_tournament ON tournament_share_v78_cleanup_replays(tournament_id,created_at DESC);


-- ===== db/migrations/V80.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_verification_chain_exports (
  id TEXT PRIMARY KEY, tournament_id TEXT, row_count INTEGER NOT NULL DEFAULT 0, integrity_sha256 TEXT, signature TEXT, key_id TEXT, created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_verification_chain_checks (
  id TEXT PRIMARY KEY, tournament_id TEXT, valid INTEGER NOT NULL DEFAULT 0, entry_count INTEGER NOT NULL DEFAULT 0, failure_count INTEGER NOT NULL DEFAULT 0, head_hash TEXT, created_at TEXT NOT NULL, detail TEXT
);
CREATE TABLE IF NOT EXISTS tournament_share_cleanup_replay_comparisons (
  id TEXT PRIMARY KEY, tournament_id TEXT, left_replay_id TEXT NOT NULL, right_replay_id TEXT NOT NULL, integrity_sha256 TEXT, payload TEXT, created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_retention_policy_consistency (
  id TEXT PRIMARY KEY, tournament_id TEXT, consistent INTEGER NOT NULL DEFAULT 0, drift_count INTEGER NOT NULL DEFAULT 0, detail TEXT, created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_chain_exports_tournament ON tournament_share_verification_chain_exports(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_chain_checks_tournament ON tournament_share_verification_chain_checks(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_cleanup_replay_comparisons_tournament ON tournament_share_cleanup_replay_comparisons(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_retention_policy_consistency_tournament ON tournament_share_retention_policy_consistency(tournament_id,created_at DESC);


-- ===== db/migrations/V81.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_verification_chain_export_checks (id TEXT PRIMARY KEY,tournament_id TEXT,export_version TEXT,integrity_valid INTEGER NOT NULL DEFAULT 0,signature_valid INTEGER NOT NULL DEFAULT 0,reason TEXT,created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS tournament_share_policy_alert_audit_chain (id TEXT PRIMARY KEY,tournament_id TEXT,alert_id TEXT,action TEXT,previous_hash TEXT,entry_hash TEXT NOT NULL,created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS tournament_share_cleanup_comparison_history (id TEXT PRIMARY KEY,tournament_id TEXT,left_replay_id TEXT,right_replay_id TEXT,integrity_sha256 TEXT,changed INTEGER NOT NULL DEFAULT 0,created_at TEXT NOT NULL,payload TEXT);
CREATE TABLE IF NOT EXISTS tournament_share_retention_remediation (id TEXT PRIMARY KEY,tournament_id TEXT,policy_version TEXT,action TEXT,status TEXT,detail TEXT,created_at TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS idx_tournament_share_chain_export_checks_tournament ON tournament_share_verification_chain_export_checks(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_policy_alert_audit_chain_tournament ON tournament_share_policy_alert_audit_chain(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_cleanup_comparison_history_tournament ON tournament_share_cleanup_comparison_history(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_retention_remediation_tournament ON tournament_share_retention_remediation(tournament_id,created_at DESC);


-- ===== db/migrations/V82.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_retention_remediation_audit (id TEXT PRIMARY KEY,tournament_id TEXT,remediation_id TEXT,action TEXT,previous_status TEXT,next_status TEXT,previous_hash TEXT,entry_hash TEXT NOT NULL,created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS tournament_share_retention_remediation_exports (id TEXT PRIMARY KEY,tournament_id TEXT,export_version TEXT,row_count INTEGER NOT NULL DEFAULT 0,integrity_sha256 TEXT,signature TEXT,key_id TEXT,created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS tournament_share_cleanup_comparison_drilldown (id TEXT PRIMARY KEY,tournament_id TEXT,comparison_id TEXT,route TEXT,left_value INTEGER NOT NULL DEFAULT 0,right_value INTEGER NOT NULL DEFAULT 0,delta INTEGER NOT NULL DEFAULT 0,created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS tournament_share_retention_policy_enforcement (id TEXT PRIMARY KEY,tournament_id TEXT,policy_version TEXT,status TEXT,candidate_count INTEGER NOT NULL DEFAULT 0,blocked_count INTEGER NOT NULL DEFAULT 0,action TEXT,detail TEXT,created_at TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS idx_tournament_share_remediation_audit_tournament ON tournament_share_retention_remediation_audit(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_remediation_exports_tournament ON tournament_share_retention_remediation_exports(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_cleanup_drilldown_comparison ON tournament_share_cleanup_comparison_drilldown(comparison_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_policy_enforcement_tournament ON tournament_share_retention_policy_enforcement(tournament_id,created_at DESC);


-- ===== db/migrations/V83.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_retention_remediation_export_verifications (id TEXT PRIMARY KEY,tournament_id TEXT,export_id TEXT,integrity_valid INTEGER NOT NULL DEFAULT 0,signature_valid INTEGER NOT NULL DEFAULT 0,reason TEXT,verified_sha256 TEXT,created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS tournament_share_cleanup_drilldown_snapshots (id TEXT PRIMARY KEY,tournament_id TEXT,comparison_id TEXT,snapshot_version TEXT,payload TEXT,integrity_sha256 TEXT,created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS tournament_share_retention_policy_incidents (id TEXT PRIMARY KEY,tournament_id TEXT,enforcement_id TEXT,status TEXT,action TEXT,detail TEXT,created_at TEXT NOT NULL,resolved_at TEXT);
CREATE TABLE IF NOT EXISTS tournament_share_scheduled_retention_replays (id TEXT PRIMARY KEY,tournament_id TEXT,run_at TEXT,status TEXT,audit_candidates INTEGER NOT NULL DEFAULT 0,cache_candidates INTEGER NOT NULL DEFAULT 0,alert_candidates INTEGER NOT NULL DEFAULT 0,remediation_candidates INTEGER NOT NULL DEFAULT 0,integrity_sha256 TEXT,payload TEXT,created_at TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS idx_tournament_share_remediation_export_verifications_tournament ON tournament_share_retention_remediation_export_verifications(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_cleanup_drilldown_snapshots_comparison ON tournament_share_cleanup_drilldown_snapshots(comparison_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_policy_incidents_tournament ON tournament_share_retention_policy_incidents(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_scheduled_retention_replays_tournament ON tournament_share_scheduled_retention_replays(tournament_id,run_at DESC);


-- ===== db/migrations/V84.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_v84_verification_replay_comparisons (id TEXT PRIMARY KEY,tournament_id TEXT,verification_count INTEGER NOT NULL DEFAULT 0,replay_count INTEGER NOT NULL DEFAULT 0,verification_failures INTEGER NOT NULL DEFAULT 0,replay_candidate_total INTEGER NOT NULL DEFAULT 0,status TEXT NOT NULL,detail TEXT,integrity_sha256 TEXT NOT NULL,created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS tournament_share_v84_policy_incident_evidence (id TEXT PRIMARY KEY,tournament_id TEXT,incident_id TEXT,enforcement_id TEXT,action TEXT,previous_status TEXT,next_status TEXT,evidence TEXT,integrity_sha256 TEXT NOT NULL,created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS tournament_share_v84_replay_health (id TEXT PRIMARY KEY,tournament_id TEXT,run_id TEXT,status TEXT,total_candidates INTEGER NOT NULL DEFAULT 0,failed_runs INTEGER NOT NULL DEFAULT 0,successful_runs INTEGER NOT NULL DEFAULT 0,integrity_sha256 TEXT NOT NULL,detail TEXT,created_at TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS idx_v84_comparison_tournament ON tournament_share_v84_verification_replay_comparisons(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_v84_incident_evidence_tournament ON tournament_share_v84_policy_incident_evidence(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_v84_replay_health_tournament ON tournament_share_v84_replay_health(tournament_id,created_at DESC);


-- ===== db/migrations/V85.sql =====
CREATE TABLE IF NOT EXISTS tournament_share_v85_production_readiness (id TEXT PRIMARY KEY,tournament_id TEXT,run_id TEXT NOT NULL,overall_status TEXT NOT NULL,checks_total INTEGER NOT NULL DEFAULT 0,checks_passed INTEGER NOT NULL DEFAULT 0,checks_failed INTEGER NOT NULL DEFAULT 0,checks_blocked INTEGER NOT NULL DEFAULT 0,integrity_sha256 TEXT NOT NULL,detail TEXT,created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS tournament_share_v85_readiness_history (id TEXT PRIMARY KEY,tournament_id TEXT,run_id TEXT NOT NULL,status TEXT NOT NULL,check_name TEXT NOT NULL,expected TEXT,actual TEXT,detail TEXT,integrity_sha256 TEXT NOT NULL,created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS tournament_share_v85_release_gates (id TEXT PRIMARY KEY,tournament_id TEXT,gate TEXT NOT NULL,status TEXT NOT NULL,detail TEXT,integrity_sha256 TEXT NOT NULL,created_at TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS idx_v85_readiness_tournament ON tournament_share_v85_production_readiness(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_v85_history_tournament ON tournament_share_v85_readiness_history(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_v85_gate_tournament ON tournament_share_v85_release_gates(tournament_id,created_at DESC);

