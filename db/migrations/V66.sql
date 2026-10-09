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
