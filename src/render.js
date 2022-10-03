
export class Camera {
  constructor(vw, vh, bx, by) {
    this.viewW = vw;
    this.viewH = vh;
    this.bufX = bx;
    this.bufY = by;
    this.xx = 0;
    this.yy = 0;
    this.limitX = 0;
    this.limitY = 0;
  }

  limit(x, y) {
    this.limitX = x - this.viewW - 1;
    this.limitY = y - this.viewH - 1;
  }

  follow(px, py) {
    if (px - this.xx - this.viewW + this.bufX > 0) {
      this.xx += 1;
    } else if (px - this.xx - this.bufX < 0) {
      this.xx -= 1;
    }

    if (py - this.yy - this.viewH + this.bufY > 0) {
      this.yy += 1;
    } else if (py - this.yy - this.bufY < 0) {
      this.yy -= 1;
    }

    this.xx = Math.max(0, Math.min(this.xx, this.limitX));
    this.yy = Math.max(0, Math.min(this.yy, this.limitY));
  }


}

class tileResource {
  constructor(id, tw, th) {
    const elem = document.querySelector(id);
    if (elem === null) {
      throw new Error(`no such image in page: ${id}`);
    }
    this.img = elem;
    this.tileW = tw;
    this.tileH = th;
    this.padX = 1;
    this.padY = 1;
    this.tilesPerRow = 50;
  }
}

const resources = [];

export function LoadTileSet(id, tw, th) {
  const tr = new tileResource(id, tw, th);
  resources.push(tr);
}

export function PutTile(ctx, index, x, y) {
  const r = resources[0];
  const ix = index % (r.tilesPerRow);
  const iy = Math.floor(index / r.tilesPerRow);
  const pixelX = (r.tileW + r.padX) * ix;
  const pixelY = (r.tileH + r.padY) * iy;
  ctx.drawImage(
    r.img,
    pixelX + r.padX, pixelY + r.padY, r.tileW, r.tileH,
    x, y, r.tileW, r.tileH
  );
}

export function DrawMap(ctx, map, cam) {
  for(let xx = 0; xx < cam.viewW; xx++) {
    for(let yy = 0; yy< cam.viewH; yy++) {
      const tile = map.get(cam.xx + xx, cam.yy + yy);
      PutTile(ctx, tile, xx*12, yy*12);
    }
  }
}
