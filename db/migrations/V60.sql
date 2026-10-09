-- V60 export integrity + cache aggregation + alert acknowledgement
CREATE TABLE IF NOT EXISTS tournament_share_alert_ack (
  share_id TEXT NOT NULL,
  alert TEXT NOT NULL,
  acknowledged_at TEXT NOT NULL,
  acknowledged_by TEXT NOT NULL,
  PRIMARY KEY(share_id, alert)
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_alert_ack_share ON tournament_share_alert_ack(share_id, acknowledged_at DESC);
