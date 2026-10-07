export type PlayerProfile = {
  username: string;
  displayName: string;
  rating: number;
  gamesPlayed: number;
  wins: number;
  draws: number;
  losses: number;
};

const KEY = 'zato.profile.v1';
const DEFAULT_PROFILE: PlayerProfile = {
  username: 'zato_player',
  displayName: 'ZATO Player',
  rating: 1200,
  gamesPlayed: 0,
  wins: 0,
  draws: 0,
  losses: 0,
};

export function loadProfile(): PlayerProfile {
  try {
    const raw = localStorage.getItem(KEY);
    return raw ? { ...DEFAULT_PROFILE, ...JSON.parse(raw) } : DEFAULT_PROFILE;
  } catch { return DEFAULT_PROFILE; }
}

export function saveProfile(profile: PlayerProfile) {
  localStorage.setItem(KEY, JSON.stringify(profile));
}

export function expectedScore(rating: number, opponent: number) {
  return 1 / (1 + Math.pow(10, (opponent - rating) / 400));
}

export function updateElo(rating: number, opponent: number, score: 0 | 0.5 | 1, k = 32) {
  return Math.max(100, Math.round(rating + k * (score - expectedScore(rating, opponent))));
}
