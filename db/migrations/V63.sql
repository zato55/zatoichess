-- V63 export signature metadata, alert audit filtering, maintenance replay diagnostics
CREATE TABLE IF NOT EXISTS tournament_share_export_keys (
  key_id TEXT PRIMARY KEY, algorithm TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'active', created_at TEXT NOT NULL, retired_at TEXT
);
CREATE TABLE IF NOT EXISTS tournament_share_maintenance_replays (
  id TEXT PRIMARY KEY, tournament_id TEXT NOT NULL, created_at TEXT NOT NULL, status TEXT NOT NULL, payload TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_maintenance_replays_tournament_created ON tournament_share_maintenance_replays(tournament_id,created_at DESC);
