-- V38 arena live scoring
ALTER TABLE matchmaking_queue ADD COLUMN arena_id TEXT;
CREATE TABLE IF NOT EXISTS arena_events (id TEXT PRIMARY KEY,label TEXT NOT NULL,time_control TEXT NOT NULL,starts_at TEXT NOT NULL,ends_at TEXT NOT NULL,status TEXT NOT NULL DEFAULT 'active',created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,CHECK(status IN ('active','finished')));
CREATE TABLE IF NOT EXISTS arena_participants (arena_id TEXT NOT NULL,user_id TEXT NOT NULL,joined_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,left_at TEXT,PRIMARY KEY(arena_id,user_id),FOREIGN KEY(arena_id) REFERENCES arena_events(id) ON DELETE CASCADE,FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE);
CREATE INDEX IF NOT EXISTS idx_arena_events_active ON arena_events(status,ends_at,time_control);
CREATE INDEX IF NOT EXISTS idx_arena_participants_user ON arena_participants(user_id,joined_at DESC);
CREATE INDEX IF NOT EXISTS idx_arena_participants_arena ON arena_participants(arena_id,joined_at);
CREATE INDEX IF NOT EXISTS idx_matchmaking_arena ON matchmaking_queue(arena_id,status,time_control,created_at);
