CREATE TABLE IF NOT EXISTS tournament_share_verification_chain_export_checks (id TEXT PRIMARY KEY,tournament_id TEXT,export_version TEXT,integrity_valid INTEGER NOT NULL DEFAULT 0,signature_valid INTEGER NOT NULL DEFAULT 0,reason TEXT,created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS tournament_share_policy_alert_audit_chain (id TEXT PRIMARY KEY,tournament_id TEXT,alert_id TEXT,action TEXT,previous_hash TEXT,entry_hash TEXT NOT NULL,created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS tournament_share_cleanup_comparison_history (id TEXT PRIMARY KEY,tournament_id TEXT,left_replay_id TEXT,right_replay_id TEXT,integrity_sha256 TEXT,changed INTEGER NOT NULL DEFAULT 0,created_at TEXT NOT NULL,payload TEXT);
CREATE TABLE IF NOT EXISTS tournament_share_retention_remediation (id TEXT PRIMARY KEY,tournament_id TEXT,policy_version TEXT,action TEXT,status TEXT,detail TEXT,created_at TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS idx_tournament_share_chain_export_checks_tournament ON tournament_share_verification_chain_export_checks(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_policy_alert_audit_chain_tournament ON tournament_share_policy_alert_audit_chain(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_cleanup_comparison_history_tournament ON tournament_share_cleanup_comparison_history(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_retention_remediation_tournament ON tournament_share_retention_remediation(tournament_id,created_at DESC);
