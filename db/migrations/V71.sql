CREATE TABLE IF NOT EXISTS tournament_share_verification_incidents (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  replay_id TEXT,
  verification_type TEXT NOT NULL,
  fingerprint TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'open',
  first_seen_at TEXT NOT NULL,
  last_seen_at TEXT NOT NULL,
  occurrences INTEGER NOT NULL DEFAULT 1,
  acknowledged_at TEXT,
  resolved_at TEXT,
  detail TEXT
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_incidents_tournament ON tournament_share_verification_incidents(tournament_id,last_seen_at DESC);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tournament_share_verification_incidents_fingerprint ON tournament_share_verification_incidents(fingerprint);
