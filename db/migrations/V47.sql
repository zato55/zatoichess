-- V47: tournament round analytics, entry-rating snapshots, replay/review history indexes
ALTER TABLE tournament_players ADD COLUMN rating_at_entry INTEGER;
UPDATE tournament_players
SET rating_at_entry = COALESCE(rating_at_entry, (SELECT rating FROM users WHERE users.id=tournament_players.user_id));

CREATE INDEX IF NOT EXISTS idx_tournament_players_rating ON tournament_players(tournament_id,rating_at_entry);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_round_status ON tournament_matches(tournament_id,round,status);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_replay_games ON tournament_matches(tiebreak_game_id,game_id);
