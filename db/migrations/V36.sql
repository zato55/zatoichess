-- ZATO Chess V36
-- Season history/reward query indexes. Safe and idempotent.
CREATE INDEX IF NOT EXISTS idx_seasons_status_ends ON seasons(status,ends_at);
CREATE INDEX IF NOT EXISTS idx_season_rewards_user ON season_rewards(user_id,created_at DESC);
