CREATE TABLE IF NOT EXISTS tournament_share_verification_exports (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  export_version TEXT NOT NULL,
  row_count INTEGER NOT NULL DEFAULT 0,
  integrity_sha256 TEXT NOT NULL,
  signature TEXT,
  key_id TEXT,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_policy_drift_alerts (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  alert_type TEXT NOT NULL,
  threshold INTEGER NOT NULL DEFAULT 0,
  observed INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'open',
  created_at TEXT NOT NULL,
  resolved_at TEXT
);
CREATE TABLE IF NOT EXISTS tournament_share_verification_replays (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  status TEXT NOT NULL,
  checks INTEGER NOT NULL DEFAULT 0,
  failures INTEGER NOT NULL DEFAULT 0,
  integrity_sha256 TEXT,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_exports_tournament ON tournament_share_verification_exports(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_policy_drift_alerts_tournament ON tournament_share_policy_drift_alerts(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_replays_tournament ON tournament_share_verification_replays(tournament_id,created_at DESC);
