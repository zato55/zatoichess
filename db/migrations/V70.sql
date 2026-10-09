CREATE TABLE IF NOT EXISTS tournament_share_verification_history (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  replay_id TEXT,
  verification_type TEXT NOT NULL,
  valid INTEGER NOT NULL DEFAULT 0,
  failure_count INTEGER NOT NULL DEFAULT 0,
  detail TEXT,
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS tournament_share_retention_runs (
  id TEXT PRIMARY KEY,
  ran_at TEXT NOT NULL,
  status TEXT NOT NULL,
  evidence_deleted INTEGER NOT NULL DEFAULT 0,
  summary_deleted INTEGER NOT NULL DEFAULT 0,
  key_chain_deleted INTEGER NOT NULL DEFAULT 0,
  verification_deleted INTEGER NOT NULL DEFAULT 0,
  error_count INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_history_tournament ON tournament_share_verification_history(tournament_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_verification_history_replay ON tournament_share_verification_history(replay_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tournament_share_retention_runs_ran_at ON tournament_share_retention_runs(ran_at DESC);
