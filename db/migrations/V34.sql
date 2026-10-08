-- ZATO Chess V34: seasonal competitive snapshots
CREATE TABLE IF NOT EXISTS season_player_stats (
  season_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  games INTEGER NOT NULL DEFAULT 0,
  wins INTEGER NOT NULL DEFAULT 0,
  draws INTEGER NOT NULL DEFAULT 0,
  losses INTEGER NOT NULL DEFAULT 0,
  start_rating INTEGER NOT NULL DEFAULT 1200,
  current_rating INTEGER NOT NULL DEFAULT 1200,
  peak_rating INTEGER NOT NULL DEFAULT 1200,
  rating_delta INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (season_id,user_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_season_stats_rank ON season_player_stats(season_id,current_rating DESC,rating_delta DESC,games DESC);
CREATE INDEX IF NOT EXISTS idx_season_stats_user ON season_player_stats(user_id,season_id);
