-- V46: tournament analytics/profile/history query indexes
CREATE INDEX IF NOT EXISTS idx_tournament_players_user ON tournament_players(user_id,tournament_id);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_winner ON tournament_matches(winner_id,tournament_id);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_players ON tournament_matches(tournament_id,player1_id,player2_id,status);
