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
