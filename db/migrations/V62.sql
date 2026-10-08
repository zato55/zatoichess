-- V62 export verification, acknowledgement audit, maintenance error telemetry, cache route comparison
CREATE TABLE IF NOT EXISTS tournament_share_alert_ack_audit (
  id TEXT PRIMARY KEY, share_id TEXT NOT NULL, alert TEXT NOT NULL, action TEXT NOT NULL,
  occurrences INTEGER NOT NULL DEFAULT 0, acknowledged_by TEXT, created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_alert_ack_audit_share_created ON tournament_share_alert_ack_audit(share_id,created_at DESC);

CREATE TABLE IF NOT EXISTS tournament_share_maintenance_errors (
  id TEXT PRIMARY KEY, run_id TEXT NOT NULL, stage TEXT NOT NULL, message TEXT NOT NULL, created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_maintenance_errors_run ON tournament_share_maintenance_errors(run_id,created_at DESC);

CREATE TABLE IF NOT EXISTS tournament_share_maintenance_run_meta (
  run_id TEXT PRIMARY KEY, status TEXT NOT NULL DEFAULT 'ok', error_count INTEGER NOT NULL DEFAULT 0
);
