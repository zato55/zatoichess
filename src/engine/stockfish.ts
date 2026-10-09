export type EngineLine = {
  depth: number;
  scoreCp: number | null;
  mate: number | null;
  bestMove: string | null;
  pv: string[];
};

export type EngineEvaluation = EngineLine & { fen: string };

export class StockfishEngine {
  private worker: Worker | null = null;
  private ready = false;
  private disposed = false;
  private initTimer: number | null = null;
  private activeResolve: ((value: EngineEvaluation) => void) | null = null;
  private activeReject: ((reason?: unknown) => void) | null = null;
  private activeFen = '';
  private activeLine: EngineLine = { depth: 0, scoreCp: null, mate: null, bestMove: null, pv: [] };
  private timer: number | null = null;

  async init(): Promise<void> {
    if (this.ready) return;
    if (this.disposed) throw new Error('Engine dispose edildi');
    if (typeof Worker === 'undefined') throw new Error('Web Worker desteklenmiyor');

    try {
      this.worker = new Worker('/stockfish-19-lite-single.js');
    } catch (e) {
      console.error('[Stockfish] Worker oluşturulamadı:', e);
      throw e;
    }

    this.worker.onmessage = (event) => this.handle(String(event.data ?? ''));
    this.worker.onerror = (err) => {
      if (this.disposed) return;
      console.error('[Stockfish] Worker hata:', err);
      this.fail(new Error('Stockfish Worker başlatılamadı: ' + (err.message || 'bilinmeyen hata')));
    };

    this.worker.postMessage('uci\n');

    await new Promise<void>((resolve, reject) => {
      this.initTimer = window.setTimeout(() => {
        if (this.disposed) return;
        window.clearInterval(check);
        if (!this.ready) {
          console.warn('[Stockfish] 15sn içinde uciok gelmedi (motor başlatılamadı)');
          reject(new Error('Stockfish UCI başlatılamadı (timeout)'));
        }
      }, 15000);

      const check = window.setInterval(() => {
        if (this.ready) {
          window.clearInterval(check);
          if (this.initTimer !== null) {
            window.clearTimeout(this.initTimer);
            this.initTimer = null;
          }
          resolve();
        }
      }, 25);
    });
  }

  async evaluate(fen: string, depth = 12): Promise<EngineEvaluation> {
    await this.init();
    if (!this.worker) throw new Error('Stockfish hazır değil');
    if (this.activeResolve) this.stop();
    this.activeFen = fen;
    this.activeLine = { depth: 0, scoreCp: null, mate: null, bestMove: null, pv: [] };
    return new Promise<EngineEvaluation>((resolve, reject) => {
      this.activeResolve = resolve;
      this.activeReject = reject;
      this.worker?.postMessage(`position fen ${fen}\n`);
      this.worker?.postMessage(`go depth ${Math.max(8, Math.min(18, depth))}\n`);
      this.timer = window.setTimeout(() => this.fail(new Error('Stockfish zaman aşımı')), 30000);
    });
  }

  stop() {
    if (!this.worker) return;
    this.worker.postMessage('stop\n');
    this.clearActive();
  }

  dispose() {
    this.disposed = true;
    if (this.initTimer !== null) {
      window.clearTimeout(this.initTimer);
      this.initTimer = null;
    }
    this.stop();
    this.worker?.terminate();
    this.worker = null;
    this.ready = false;
  }

  private handle(line: string) {
    const trimmed = line.trim();
    if (!trimmed) return;

    if (trimmed === 'uciok') {
      this.worker?.postMessage('setoption name Threads value 1\n');
      this.worker?.postMessage('isready\n');
      return;
    }
    if (trimmed === 'readyok') {
      this.ready = true;
      return;
    }
    if (!this.activeResolve) return;
    if (trimmed.startsWith('info ')) {
      const depth = /\bdepth (\d+)/.exec(trimmed);
      if (depth) this.activeLine.depth = Number(depth[1]);
      const score = /\bscore (cp|mate) (-?\d+)/.exec(trimmed);
      if (score) {
        if (score[1] === 'cp') { this.activeLine.scoreCp = Number(score[2]); this.activeLine.mate = null; }
        else { this.activeLine.mate = Number(score[2]); this.activeLine.scoreCp = null; }
      }
      const pv = /\bpv (.+)$/.exec(trimmed);
      if (pv) this.activeLine.pv = pv[1].trim().split(/\s+/);
      return;
    }
    if (trimmed.startsWith('bestmove ')) {
      const best = /^bestmove\s+(\S+)/.exec(trimmed);
      this.activeLine.bestMove = best && best[1] !== '(none)' ? best[1] : null;
      const result: EngineEvaluation = { fen: this.activeFen, ...this.activeLine };
      const resolve = this.activeResolve;
      this.clearActive();
      resolve(result);
    }
  }

  private fail(error: Error) {
    const reject = this.activeReject;
    this.clearActive();
    reject?.(error);
  }

  private clearActive() {
    if (this.timer !== null) window.clearTimeout(this.timer);
    this.timer = null;
    this.activeResolve = null;
    this.activeReject = null;
  }
}