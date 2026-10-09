-- V52 public share rate limiting + privacy-safe daily analytics
CREATE TABLE IF NOT EXISTS tournament_share_rate_limits (
  token_hash TEXT NOT NULL,
  window_start TEXT NOT NULL,
  hits INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (token_hash, window_start)
);
CREATE TABLE IF NOT EXISTS tournament_share_daily (
  share_id TEXT NOT NULL,
  day TEXT NOT NULL,
  views INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (share_id, day)
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_daily_share_day ON tournament_share_daily(share_id, day DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_rate_window ON tournament_share_rate_limits(window_start);
