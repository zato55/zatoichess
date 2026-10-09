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
