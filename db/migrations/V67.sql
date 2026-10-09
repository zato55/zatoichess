CREATE TABLE IF NOT EXISTS tournament_share_contract_replay_evidence (
  id TEXT PRIMARY KEY,
  replay_id TEXT NOT NULL,
  route TEXT NOT NULL,
  status_code INTEGER NOT NULL,
  cache_marker TEXT,
  etag TEXT,
  body_hash TEXT,
  error_code TEXT,
  detail TEXT,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_key_rotation_audit (
  id TEXT PRIMARY KEY,
  run_id TEXT,
  previous_key_id TEXT,
  active_key_id TEXT NOT NULL,
  action TEXT NOT NULL,
  passed INTEGER NOT NULL DEFAULT 0,
  detail TEXT,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_maintenance_replay_runs (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  source_replay_id TEXT,
  replay_hash TEXT NOT NULL,
  status TEXT NOT NULL,
  deterministic INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_contract_evidence_replay ON tournament_share_contract_replay_evidence(replay_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_key_rotation_audit_created ON tournament_share_key_rotation_audit(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_maintenance_replay_runs_tournament ON tournament_share_maintenance_replay_runs(tournament_id,created_at DESC);
