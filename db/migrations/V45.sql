-- V45 tournament rating isolation + standings indexes
CREATE INDEX IF NOT EXISTS idx_tournament_matches_tournament_winner ON tournament_matches(tournament_id,winner_id,status);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_players ON tournament_matches(tournament_id,player1_id,player2_id,status);
