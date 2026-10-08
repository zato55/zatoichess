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
