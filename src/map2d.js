
export function FromLayer(tiledData, layerName) {
  if (!tiledData) {
    throw new Error("tiled data must be non-null");
  }
  if (!tiledData.layers) {
    throw new Error("tiled data has no layers");
  }

  for (let l of tiledData.layers) {
    if (l.name !== layerName) {
      continue;
    }

    const ww = l.width;
    const hh = l.height;
    const tiles = window.atob(l.data);

    const mm = new Map2D(ww, hh);
    for(let i = 0; i < Math.floor(tiles.length / 4); i++) {
      const cs = [
        tiles.charCodeAt((4*i) + 0),
        tiles.charCodeAt((4*i) + 1),
        tiles.charCodeAt((4*i) + 2),
        tiles.charCodeAt((4*i) + 3),
      ];
      const ti = cs[0] | (cs[1] << 8) | (cs[2] << 16) | (cs[3] << 24);
      mm.set(i%ww, Math.floor(i/ww), ti-1);
    }
    return mm;
  }

  throw new Error(`no such layer ${layerName} in tiled map`);
}


export class Map2D {
  constructor(w, h) {
    this.w = w;
    this.h = h;
    this.map = new Array(w*h);
  }

  set(x, y, i) {
    if (x < 0 || x >= this.w || y < 0 || y >= this.h) {
      throw new Error(`out of bounds set: ${x}, ${y}`);
    }
    this.map[(y * this.w) + x] = i;
  }

  get(x, y) {
    if (x < 0 || x >= this.w || y < 0 || y >= this.h) {
      return 99999;
    }
    return this.map[(y * this.w) + x];
  }
}
