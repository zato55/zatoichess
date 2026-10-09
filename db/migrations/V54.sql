-- V54 public share abuse telemetry (aggregate, privacy-safe)
CREATE TABLE IF NOT EXISTS tournament_share_abuse_windows (
  token_hash TEXT NOT NULL,
  window_start TEXT NOT NULL,
  allowed_hits INTEGER NOT NULL DEFAULT 0,
  blocked_hits INTEGER NOT NULL DEFAULT 0,
  last_blocked_at TEXT,
  PRIMARY KEY (token_hash, window_start)
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_abuse_window ON tournament_share_abuse_windows(window_start);
CREATE INDEX IF NOT EXISTS idx_tournament_share_abuse_token ON tournament_share_abuse_windows(token_hash, window_start DESC);
