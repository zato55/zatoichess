-- V57 public share audit retention and daily aggregation
CREATE TABLE IF NOT EXISTS tournament_share_audit_daily (
  day TEXT NOT NULL,
  tournament_id TEXT NOT NULL,
  share_id TEXT NOT NULL,
  event TEXT NOT NULL,
  count INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY(day, tournament_id, share_id, event)
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_audit_daily_tournament ON tournament_share_audit_daily(tournament_id, day DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_audit_daily_share ON tournament_share_audit_daily(share_id, day DESC);
