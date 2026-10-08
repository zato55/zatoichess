-- V41 anti-abuse + daily/weekly cup
CREATE TABLE IF NOT EXISTS arena_join_log (
  id TEXT PRIMARY KEY,
  arena_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  action TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (action IN ('join','leave')),
  FOREIGN KEY (arena_id) REFERENCES arena_events(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_arena_join_log_user_created ON arena_join_log(user_id,created_at DESC);

CREATE TABLE IF NOT EXISTS cup_events (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  kind TEXT NOT NULL,
  starts_at TEXT NOT NULL,
  ends_at TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (kind IN ('daily','weekly')),
  CHECK (status IN ('active','finished'))
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_cup_events_kind_start ON cup_events(kind,starts_at);
CREATE INDEX IF NOT EXISTS idx_cup_events_status_ends ON cup_events(status,ends_at);

CREATE TABLE IF NOT EXISTS cup_participants (
  cup_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  joined_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  left_at TEXT,
  PRIMARY KEY (cup_id,user_id),
  FOREIGN KEY (cup_id) REFERENCES cup_events(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_cup_participants_user ON cup_participants(user_id,joined_at DESC);
CREATE INDEX IF NOT EXISTS idx_cup_participants_cup ON cup_participants(cup_id,joined_at);

CREATE TABLE IF NOT EXISTS cup_rewards (
  id TEXT PRIMARY KEY,
  cup_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  rank INTEGER NOT NULL,
  reward_key TEXT NOT NULL,
  points INTEGER NOT NULL DEFAULT 0,
  games INTEGER NOT NULL DEFAULT 0,
  wins INTEGER NOT NULL DEFAULT 0,
  draws INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(cup_id,user_id),
  FOREIGN KEY (cup_id) REFERENCES cup_events(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_cup_rewards_user_created ON cup_rewards(user_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_cup_rewards_cup_rank ON cup_rewards(cup_id,rank);
