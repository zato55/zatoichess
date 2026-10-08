-- ZATO Chess V31 migration
-- Adds persisted Stockfish centipawn loss so ACPL/accuracy can be calculated server-side.
ALTER TABLE analyses ADD COLUMN loss_cp INTEGER DEFAULT 0;
