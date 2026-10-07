export type SavedGame = {
  id: string;
  whiteName: string;
  blackName: string;
  timeControl: string;
  result: string;
  status: 'playing' | 'finished' | 'aborted';
  pgn: string;
  finalFen?: string;
  startedAt: string;
  endedAt?: string;
};

const KEY = 'zato.games.v5';

export function loadSavedGames(): SavedGame[] {
  try {
    const raw = localStorage.getItem(KEY);
    return raw ? JSON.parse(raw) : [];
  } catch { return []; }
}

export function saveGame(game: SavedGame) {
  const games = loadSavedGames().filter(g => g.id !== game.id);
  localStorage.setItem(KEY, JSON.stringify([game, ...games].slice(0, 50)));
}
