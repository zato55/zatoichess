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
