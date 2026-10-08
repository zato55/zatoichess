CREATE TABLE IF NOT EXISTS tournament_share_verification_chain_exports (
  id TEXT PRIMARY KEY, tournament_id TEXT, row_count INTEGER NOT NULL DEFAULT 0, integrity_sha256 TEXT, signature TEXT, key_id TEXT, created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_verification_chain_checks (
  id TEXT PRIMARY KEY, tournament_id TEXT, valid INTEGER NOT NULL DEFAULT 0, entry_count INTEGER NOT NULL DEFAULT 0, failure_count INTEGER NOT NULL DEFAULT 0, head_hash TEXT, created_at TEXT NOT NULL, detail TEXT
);
CREATE TABLE IF NOT EXISTS tournament_share_cleanup_replay_comparisons (
  id TEXT PRIMARY KEY, tournament_id TEXT, left_replay_id TEXT NOT NULL, right_replay_id TEXT NOT NULL, integrity_sha256 TEXT, payload TEXT, created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_retention_policy_consistency (
  id TEXT PRIMARY KEY, tournament_id TEXT, consistent INTEGER NOT NULL DEFAULT 0, drift_count INTEGER NOT NULL DEFAULT 0, detail TEXT, created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_chain_exports_tournament ON tournament_share_verification_chain_exports(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_chain_checks_tournament ON tournament_share_verification_chain_checks(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_cleanup_replay_comparisons_tournament ON tournament_share_cleanup_replay_comparisons(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_retention_policy_consistency_tournament ON tournament_share_retention_policy_consistency(tournament_id,created_at DESC);
