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
