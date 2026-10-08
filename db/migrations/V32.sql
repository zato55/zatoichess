-- ZATO Chess V32 production/readiness indexes
CREATE INDEX IF NOT EXISTS idx_games_finished_time_control ON games(status,time_control,ended_at DESC);
CREATE INDEX IF NOT EXISTS idx_games_white_finished ON games(white_user_id,status,ended_at DESC);
CREATE INDEX IF NOT EXISTS idx_games_black_finished ON games(black_user_id,status,ended_at DESC);
CREATE INDEX IF NOT EXISTS idx_analyses_game_loss ON analyses(game_id,loss_cp);
CREATE INDEX IF NOT EXISTS idx_rating_history_game_user ON rating_history(game_id,user_id);
