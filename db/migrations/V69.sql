CREATE TABLE IF NOT EXISTS tournament_share_evidence_retention (
  scope TEXT PRIMARY KEY,
  evidence_days INTEGER NOT NULL DEFAULT 90,
  summary_days INTEGER NOT NULL DEFAULT 180,
  key_chain_days INTEGER NOT NULL DEFAULT 365,
  updated_at TEXT NOT NULL
);
INSERT OR IGNORE INTO tournament_share_evidence_retention(scope,evidence_days,summary_days,key_chain_days,updated_at)
VALUES ('public-share',90,180,365,datetime('now'));
CREATE INDEX IF NOT EXISTS idx_tournament_share_evidence_retention_updated ON tournament_share_evidence_retention(updated_at DESC);
