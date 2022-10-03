import {Camera, PutTile, DrawMap} from "./render";
import {FromLayer} from "./map2d";

export class Game {
  constructor(name, mapData) {
    this.mapName = name; 
    this.acc = 0;
    this.xx = 0;
    this.yy = 0;
    this.ev = new Set();
    this.tiles = FromLayer(mapData, "map");
    this.col = FromLayer(mapData, "collision");
    this.cam = new Camera(27, 20, 10, 8);
    this.cam.limit(this.tiles.w, this.tiles.h);
  }

  update(dt) {
    this.acc += dt;
    // make a shallow copy
    const cc = this.ev;
    this.ev = new Set();
    let dx = 0;
    let dy = 0;
    for (let e of cc) {
      switch (e) {
        case "R":
          dx += 1;
          break;
        case "L":
          dx -= 1;
          break;
        case "U":
          dy -= 1;
          break;
        case "D":
          dy += 1;
          break;
      }
    }

    if (this.col.get(this.xx + dx, this.yy + dy) == -1) {
      this.xx += dx; 
      this.yy += dy;
    }

    this.cam.follow(this.xx, this.yy);
  }

  draw(_, ctx) {
    ctx.fillStyle = "black";
    ctx.fillRect(0,0,320,240);
    DrawMap(ctx, this.tiles, this.cam);
    PutTile(ctx, 26, (this.xx - this.cam.xx) * 12, (this.yy - this.cam.yy)*12);
  }

  keydown(e) {
    if (e == "a") {
      this.ev.add("L");
    } else if (e == "d") {
      this.ev.add("R");
    } else if (e == "s") {
      this.ev.add("D");
    } else if (e == "w") {
      this.ev.add("U");
    } else if (e == "e") {
      this.ev.add("X");
    }
  }
}

