CREATE TABLE IF NOT EXISTS tournament_share_contract_replay_summary (
  replay_id TEXT PRIMARY KEY,
  tournament_id TEXT,
  total_routes INTEGER NOT NULL DEFAULT 0,
  passed_routes INTEGER NOT NULL DEFAULT 0,
  failed_routes INTEGER NOT NULL DEFAULT 0,
  conditional_hits INTEGER NOT NULL DEFAULT 0,
  origin_hits INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_key_audit_chain (
  id TEXT PRIMARY KEY,
  audit_id TEXT NOT NULL,
  previous_hash TEXT,
  entry_hash TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_contract_summary_tournament ON tournament_share_contract_replay_summary(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_key_audit_chain_audit ON tournament_share_key_audit_chain(audit_id,created_at DESC);
