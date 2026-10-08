-- V56 public share audit trail
CREATE TABLE IF NOT EXISTS tournament_share_audit (
  id TEXT PRIMARY KEY,
  tournament_id TEXT NOT NULL,
  share_id TEXT NOT NULL,
  event TEXT NOT NULL,
  metadata TEXT NOT NULL DEFAULT '{}',
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_audit_tournament ON tournament_share_audit(tournament_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_audit_share ON tournament_share_audit(share_id, created_at DESC);
