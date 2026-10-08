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
