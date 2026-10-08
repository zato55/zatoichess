-- ZATO Chess V39: Arena rewards and player metrics
CREATE TABLE IF NOT EXISTS arena_rewards (
  id TEXT PRIMARY KEY,
  arena_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  rank INTEGER NOT NULL,
  reward_key TEXT NOT NULL,
  points INTEGER NOT NULL DEFAULT 0,
  games INTEGER NOT NULL DEFAULT 0,
  wins INTEGER NOT NULL DEFAULT 0,
  draws INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(arena_id,user_id),
  FOREIGN KEY (arena_id) REFERENCES arena_events(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_arena_rewards_user_created ON arena_rewards(user_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_arena_rewards_arena_rank ON arena_rewards(arena_id,rank);
