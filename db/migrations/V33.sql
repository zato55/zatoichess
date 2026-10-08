-- ZATO Chess V33: competitive season / rank-tier support.
-- Season stats are derived from existing games + rating_history, so no backfill is required.
CREATE INDEX IF NOT EXISTS idx_games_finished_ended ON games(status, ended_at DESC);
CREATE INDEX IF NOT EXISTS idx_rating_history_game_user ON rating_history(game_id, user_id);
