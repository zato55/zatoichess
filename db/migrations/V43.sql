-- V43 tournament hardening: explicit draw tie-break + tournament notifications
ALTER TABLE tournament_matches ADD COLUMN tie_break TEXT NOT NULL DEFAULT 'none';
ALTER TABLE tournament_matches ADD COLUMN winner_reason TEXT NOT NULL DEFAULT 'game_result';
ALTER TABLE notification_preferences ADD COLUMN tournament_update INTEGER NOT NULL DEFAULT 1;
CREATE INDEX IF NOT EXISTS idx_tournament_matches_status ON tournament_matches(tournament_id,status,round,match_no);
