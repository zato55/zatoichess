CREATE TABLE IF NOT EXISTS tournament_share_verification_incident_audit (
  id TEXT PRIMARY KEY,
  incident_id TEXT NOT NULL,
  tournament_id TEXT,
  action TEXT NOT NULL,
  previous_status TEXT,
  next_status TEXT NOT NULL,
  occurrences INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  detail TEXT
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_incident_audit_incident ON tournament_share_verification_incident_audit(incident_id,created_at DESC);

CREATE TABLE IF NOT EXISTS tournament_share_retention_errors (
  id TEXT PRIMARY KEY,
  run_id TEXT NOT NULL,
  stage TEXT NOT NULL,
  message TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_retention_errors_run ON tournament_share_retention_errors(run_id,created_at DESC);

CREATE TABLE IF NOT EXISTS tournament_share_replay_comparisons (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  left_replay_id TEXT NOT NULL,
  right_replay_id TEXT NOT NULL,
  route_count INTEGER NOT NULL DEFAULT 0,
  changed_routes INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  payload TEXT NOT NULL,
  integrity_sha256 TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_replay_comparisons_tournament ON tournament_share_replay_comparisons(tournament_id,created_at DESC);
