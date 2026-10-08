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
