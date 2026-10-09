-- V58 share health dashboard indexes and alert-ready retention support
CREATE INDEX IF NOT EXISTS idx_tournament_share_audit_daily_event_day ON tournament_share_audit_daily(event, day DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_audit_tournament_created ON tournament_share_audit(tournament_id, created_at DESC);
