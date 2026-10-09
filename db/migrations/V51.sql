-- V51 share security + privacy controls
ALTER TABLE tournament_shares ADD COLUMN expires_at TEXT;
ALTER TABLE tournament_shares ADD COLUMN visibility TEXT NOT NULL DEFAULT 'public';
UPDATE tournament_shares SET expires_at=datetime(created_at,'+30 days') WHERE expires_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_tournament_shares_active ON tournament_shares(tournament_id,revoked_at,expires_at);
