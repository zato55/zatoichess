CREATE TABLE IF NOT EXISTS tournament_share_replay_bundle_verifications (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  bundle_sha256 TEXT NOT NULL,
  signature_valid INTEGER NOT NULL DEFAULT 0,
  integrity_valid INTEGER NOT NULL DEFAULT 0,
  reason TEXT,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_bundle_verifications_tournament ON tournament_share_replay_bundle_verifications(tournament_id,created_at DESC);
CREATE TABLE IF NOT EXISTS tournament_share_cleanup_replay_history (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  replay_id TEXT NOT NULL,
  candidate_evidence INTEGER NOT NULL DEFAULT 0,
  candidate_snapshots INTEGER NOT NULL DEFAULT 0,
  candidate_diffs INTEGER NOT NULL DEFAULT 0,
  candidate_signatures INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  integrity_sha256 TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_cleanup_replay_history_tournament ON tournament_share_cleanup_replay_history(tournament_id,created_at DESC);
CREATE TABLE IF NOT EXISTS tournament_share_retention_policy_checks (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  policy_version TEXT NOT NULL,
  consistent INTEGER NOT NULL DEFAULT 0,
  policies TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_retention_policy_checks_tournament ON tournament_share_retention_policy_checks(tournament_id,created_at DESC);
