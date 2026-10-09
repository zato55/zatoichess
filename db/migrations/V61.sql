-- V61 export verification + alert lifecycle + maintenance diagnostics
CREATE TABLE IF NOT EXISTS tournament_share_alert_ack_v61 (
  share_id TEXT NOT NULL,
  alert TEXT NOT NULL,
  acknowledged_at TEXT NOT NULL,
  acknowledged_by TEXT NOT NULL,
  acknowledged_occurrences INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY(share_id, alert)
);
INSERT OR IGNORE INTO tournament_share_alert_ack_v61(share_id,alert,acknowledged_at,acknowledged_by,acknowledged_occurrences)
SELECT share_id,alert,acknowledged_at,acknowledged_by,0 FROM tournament_share_alert_ack;
DROP INDEX IF EXISTS idx_tournament_share_alert_ack_share;
DROP TABLE IF EXISTS tournament_share_alert_ack;
ALTER TABLE tournament_share_alert_ack_v61 RENAME TO tournament_share_alert_ack;
CREATE INDEX IF NOT EXISTS idx_tournament_share_alert_ack_share ON tournament_share_alert_ack(share_id, acknowledged_at DESC);

CREATE TABLE IF NOT EXISTS tournament_share_maintenance_runs (
  id TEXT PRIMARY KEY,
  ran_at TEXT NOT NULL,
  audit_aggregated INTEGER NOT NULL DEFAULT 0,
  audit_deleted INTEGER NOT NULL DEFAULT 0,
  cache_deleted INTEGER NOT NULL DEFAULT 0,
  alerts_deleted INTEGER NOT NULL DEFAULT 0,
  rate_limits_deleted INTEGER NOT NULL DEFAULT 0,
  abuse_windows_deleted INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_maintenance_runs_ran_at ON tournament_share_maintenance_runs(ran_at DESC);
