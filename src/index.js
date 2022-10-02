
(async function() {
  const { LuaFactory } = require('wasmoon');

  const factory = new LuaFactory();
  const module = await factory.getLuaModule();

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
    keydown: () => {},
    _wupdate: () => {},
    _wdraw: () => {},
    _wkeydown: () => {},
    isDebug: false,
    debugOn: (ctx) => {
      jsProg.isDebug = true;    
      console.log(">>>> DEBUGGER ACTIVATED <<<<");
      console.log(" --- binding dbg functions ---");
      console.log(" (*) dbgLocals (*) dbgEval (*) dbgQuit (*) ");
      console.dir(ctx.inf);
      console.dir(ctx.trace);
      console.dir(ctx.locals);
      debugOn(ctx, () => {
        jsProg.isDebug = false;
      });
    },
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
    if (jsProg.isDebug) {
      return;
    }
    let dt = (now - then) / 1000;
    then = now;
    frameAcc += dt;
    if (frameAcc > dFPS) {
      frameAcc = 0;
      if (!jsProg.pause) {
        jsProg._wupdate(dt);
        jsProg._wdraw(dt, drawContext);
      }
    }
  }

  update(then);

  window.onkeydown = (e) => jsProg._wkeydown(e);
  window.breakpoint = (file, line) => {
    jsProg.breakpoints.push({file, line});
  };

  function debugOn(d, done) {
    window.dbgQuit = () => {
      window.D = undefined;
      window.dbgQuit = undefined;
      window.dbgLocals = undefined;
      window.dbgEval = undefined;
      for (let k in d.jsScope) {
        window[k] = undefined;
      }
      done();
    }
    window.dbgLocals = (i) => {
      console.dir(d.locals);
    }
    window.dbgEval = (ll) => {
      const res = d.eval(ll);
      console.dir(res);
    }
    window.D = d;
    for (let k in d.jsScope) {
      window[k] = d.jsScope[k];
    }
  }

})();
