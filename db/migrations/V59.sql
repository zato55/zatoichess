-- V59 cache-aware analytics + alert history + health export
CREATE TABLE IF NOT EXISTS tournament_share_cache_daily (
  day TEXT NOT NULL,
  tournament_id TEXT NOT NULL,
  share_id TEXT NOT NULL,
  route TEXT NOT NULL,
  origin_hits INTEGER NOT NULL DEFAULT 0,
  conditional_hits INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY(day, share_id, route)
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_cache_daily_tournament_day ON tournament_share_cache_daily(tournament_id, day DESC);
CREATE TABLE IF NOT EXISTS tournament_share_alert_history (
  id TEXT PRIMARY KEY,
  tournament_id TEXT NOT NULL,
  share_id TEXT NOT NULL,
  alert TEXT NOT NULL,
  first_seen_at TEXT NOT NULL,
  last_seen_at TEXT NOT NULL,
  occurrences INTEGER NOT NULL DEFAULT 1
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tournament_share_alert_unique ON tournament_share_alert_history(share_id, alert);
CREATE INDEX IF NOT EXISTS idx_tournament_share_alert_tournament ON tournament_share_alert_history(tournament_id, last_seen_at DESC);
