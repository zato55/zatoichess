import { mkdir, copyFile, access } from 'node:fs/promises';
import { join } from 'node:path';

const root = new URL('..', import.meta.url).pathname;
const source = join(root, 'node_modules', 'stockfish', 'bin');
const target = join(root, 'public');
await mkdir(target, { recursive: true });
for (const file of ['stockfish-19-lite-single.js', 'stockfish-19-lite-single.wasm']) {
  const from = join(source, file);
  const to = join(target, file);
  try { await access(from); await copyFile(from, to); }
  catch { console.warn(`[ZATO] Stockfish asset missing: ${file}. Run npm install first.`); }
}
