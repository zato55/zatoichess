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
