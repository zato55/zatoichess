-- V44 tournament quality expansion: replay tie-breaks + history
ALTER TABLE tournaments ADD COLUMN tiebreak_mode TEXT NOT NULL DEFAULT 'seed';
ALTER TABLE tournament_matches ADD COLUMN tiebreak_game_id TEXT;
ALTER TABLE tournament_matches ADD COLUMN tiebreak_room_code TEXT;
CREATE INDEX IF NOT EXISTS idx_tournament_matches_tiebreak_game ON tournament_matches(tiebreak_game_id);
CREATE INDEX IF NOT EXISTS idx_tournament_matches_tiebreak_room ON tournament_matches(tiebreak_room_code);
CREATE INDEX IF NOT EXISTS idx_tournaments_finished_ends ON tournaments(status,ends_at DESC);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tournament_matches_tiebreak_room_unique ON tournament_matches(tiebreak_room_code) WHERE tiebreak_room_code IS NOT NULL;
