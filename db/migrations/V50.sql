-- V50 public share analytics
ALTER TABLE tournament_shares ADD COLUMN views_count INTEGER NOT NULL DEFAULT 0;
ALTER TABLE tournament_shares ADD COLUMN last_viewed_at TEXT;
CREATE INDEX IF NOT EXISTS idx_tournament_shares_views ON tournament_shares(views_count DESC);
