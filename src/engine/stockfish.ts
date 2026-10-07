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
  private activeResolve: ((value: EngineEvaluation) => void) | null = null;
  private activeReject: ((reason?: unknown) => void) | null = null;
  private activeFen = '';
  private activeLine: EngineLine = { depth: 0, scoreCp: null, mate: null, bestMove: null, pv: [] };
  private timer: number | null = null;

  async init(): Promise<void> {
    if (this.ready) return;
    if (typeof Worker === 'undefined') throw new Error('Web Worker desteklenmiyor');
    this.worker = new Worker('/stockfish-19-lite-single.js');
    this.worker.onmessage = (event) => this.handle(String(event.data ?? ''));
    this.worker.onerror = () => this.fail(new Error('Stockfish Worker başlatılamadı'));
    this.worker.postMessage('uci');
    await new Promise<void>((resolve, reject) => {
      const check = window.setInterval(() => {
        if (this.ready) { window.clearInterval(check); resolve(); }
      }, 25);
      window.setTimeout(() => {
        window.clearInterval(check);
        if (!this.ready) reject(new Error('Stockfish UCI başlatılamadı'));
      }, 10000);
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
      this.worker?.postMessage(`position fen ${fen}`);
      this.worker?.postMessage(`go depth ${Math.max(8, Math.min(18, depth))}`);
      this.timer = window.setTimeout(() => this.fail(new Error('Stockfish zaman aşımı')), 30000);
    });
  }

  stop() {
    if (!this.worker) return;
    this.worker.postMessage('stop');
    this.clearActive();
  }

  dispose() {
    this.stop();
    this.worker?.terminate();
    this.worker = null;
    this.ready = false;
  }

  private handle(line: string) {
    if (line === 'uciok') {
      this.worker?.postMessage('setoption name Threads value 1');
      this.worker?.postMessage('isready');
      return;
    }
    if (line === 'readyok') {
      this.ready = true;
      return;
    }
    if (!this.activeResolve) return;
    if (line.startsWith('info ')) {
      const depth = /\bdepth (\d+)/.exec(line);
      if (depth) this.activeLine.depth = Number(depth[1]);
      const score = /\bscore (cp|mate) (-?\d+)/.exec(line);
      if (score) {
        if (score[1] === 'cp') { this.activeLine.scoreCp = Number(score[2]); this.activeLine.mate = null; }
        else { this.activeLine.mate = Number(score[2]); this.activeLine.scoreCp = null; }
      }
      const pv = /\bpv (.+)$/.exec(line);
      if (pv) this.activeLine.pv = pv[1].trim().split(/\s+/);
      return;
    }
    if (line.startsWith('bestmove ')) {
      const best = /^bestmove\s+(\S+)/.exec(line);
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
