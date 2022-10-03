
import {Game} from "./game";
import {LoadTileSet} from "./render";

const canvas = document.createElement("canvas");
canvas.width = 320;
canvas.height = 240;
document.body.appendChild(canvas);
const drawContext = canvas.getContext("2d");

LoadTileSet("#spritesheet", 12, 12);

let then = performance.now();
const FPS = 30;
const dFPS = 1 / FPS;
let frameAcc = 0;

const nullState = {
  update: () => {},
  draw: () => {},
  keydown: () => {},
  blockNext: true,
}

const globalState = {
  pause: false,
  errorFlagged: true,
  stack: [nullState],
  push: (st) => {
    globalState.stack.push(st);
  },
  pop: () => {
    globalState.stack.pop();
  },
};

function update(now) {
  window.requestAnimationFrame(update);
  if (globalState.pause) {
    return;
  }
  let dt = (now - then) / 1000;
  then = now;
  frameAcc += dt;
  if (frameAcc > dFPS) {
    frameAcc = 0;
    try {
      const state = globalState.stack[globalState.stack.length - 1];
      state.update(dt);
      state.draw(dt, drawContext);
    } catch (e) {
      console.log("failed main loop lua callback");
      console.error(e);
      globalState.pause = true;
    } 
  }
}

update(then);

window.onkeydown = (e) => {
  try {
    const state = globalState.stack[globalState.stack.length - 1];
    state.keydown(e.key); 
  } catch (e) {
    console.log("failed keydown event");
    console.error(e);
    globalState.pause = true;
  }
}

window.resume = () => {
  globalState.pause = false;
}

fetch("./map1.json").then(d => d.json()).then(d => {
  globalState.push(new Game("map1", d));
});

