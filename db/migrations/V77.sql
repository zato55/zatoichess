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
