-- V64 signed export verification, key lifecycle, maintenance replay snapshots
CREATE TABLE IF NOT EXISTS tournament_share_export_key_events (
  id TEXT PRIMARY KEY, key_id TEXT NOT NULL, action TEXT NOT NULL, created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_export_key_events_key_created ON tournament_share_export_key_events(key_id,created_at DESC);
