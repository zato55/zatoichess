-- V49 public tournament shares
CREATE TABLE IF NOT EXISTS tournament_shares (
  id TEXT PRIMARY KEY,
  tournament_id TEXT NOT NULL,
  token_hash TEXT NOT NULL UNIQUE,
  created_by TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  revoked_at TEXT,
  FOREIGN KEY (tournament_id) REFERENCES tournaments(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tournament_shares_active ON tournament_shares(tournament_id) WHERE revoked_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_tournament_shares_token ON tournament_shares(token_hash);
