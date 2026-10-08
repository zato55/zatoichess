CREATE TABLE IF NOT EXISTS tournament_share_verification_export_checks (
  id TEXT PRIMARY KEY, tournament_id TEXT, export_version TEXT NOT NULL, integrity_valid INTEGER NOT NULL DEFAULT 0, signature_valid INTEGER NOT NULL DEFAULT 0, reason TEXT, created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_policy_drift_ack (
  id TEXT PRIMARY KEY, tournament_id TEXT, alert_id TEXT NOT NULL, action TEXT NOT NULL, created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_replay_history_checks (
  id TEXT PRIMARY KEY, tournament_id TEXT, replay_id TEXT NOT NULL, history_id TEXT, integrity_valid INTEGER NOT NULL DEFAULT 0, reason TEXT, created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_v78_cleanup_replays (
  id TEXT PRIMARY KEY, tournament_id TEXT, candidate_exports INTEGER NOT NULL DEFAULT 0, candidate_alerts INTEGER NOT NULL DEFAULT 0, candidate_replays INTEGER NOT NULL DEFAULT 0, integrity_sha256 TEXT, created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_export_checks_tournament ON tournament_share_verification_export_checks(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_policy_drift_ack_tournament ON tournament_share_policy_drift_ack(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_replay_history_checks_tournament ON tournament_share_replay_history_checks(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_v78_cleanup_replays_tournament ON tournament_share_v78_cleanup_replays(tournament_id,created_at DESC);
