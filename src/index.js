
(async function() {
  const { LuaFactory } = require('wasmoon');

  const factory = new LuaFactory();

  async function mountFile(path) {
    return fetch(path)
      .then(res => res.text())
      .then(t => factory.mountFile(path, t))
      .catch(err => console.error(err));
  }

  function mountFiles(mounts, next) {
    const promises = [];
    for(let path of mounts) {
      const pr = mountFile(`./${path}.lua`);
      promises.push(pr);
    }
    Promise.all(promises)
      .then(next)
      .catch(console.error);
  }

  await mountFile("./entry.lua");

  const lua = await factory.createEngine();

  lua.global.set("DOM", {
    "create": (n) => document.createElement(n),
    "query": (q) => document.querySelector(q),
  });

  const jsProg = {
    pause: false,
    mountFiles: mountFiles,
    update: () => {},
    draw: () => {},
  };

  lua.global.set("JSPROG", jsProg); 
  lua.global.set("prettyPrint", console.dir);

  await lua.doString(`
    require"entry"
   `);

  const canvas = document.querySelector("#canvas");
  const drawContext = canvas.getContext("2d");

  let then = performance.now();
  const FPS = 30;
  const dFPS = 1 / FPS;
  let frameAcc = 0;

  function update(now) {
    window.requestAnimationFrame(update);
    let dt = (now - then) / 1000;
    then = now;
    frameAcc += dt;
    if (frameAcc > dFPS) {
      if (!jsProg.pause) {
        jsProg.update(dt);
        jsProg.draw(dt, drawContext);
      }
      frameAcc -= dFPS;
    }
  }

  update(then);

  window.onkeydown = (e) => jsProg.keydown(e);

})();
