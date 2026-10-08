-- V65 signature rotation harness, replay diff persistence, route contract runs
CREATE TABLE IF NOT EXISTS tournament_share_maintenance_replay_diffs (
  id TEXT PRIMARY KEY,
  replay_id TEXT NOT NULL,
  previous_replay_id TEXT,
  created_at TEXT NOT NULL,
  diff_json TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_maintenance_replay_diffs_replay_created ON tournament_share_maintenance_replay_diffs(replay_id,created_at DESC);
CREATE TABLE IF NOT EXISTS tournament_share_route_contract_runs (
  id TEXT PRIMARY KEY,
  tournament_id TEXT,
  route TEXT NOT NULL,
  method TEXT NOT NULL,
  expected_status INTEGER NOT NULL,
  expected_cache TEXT,
  observed_status INTEGER,
  observed_cache TEXT,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tournament_share_route_contract_runs_tournament_created ON tournament_share_route_contract_runs(tournament_id,created_at DESC);
