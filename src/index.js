
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

  lua.global.set("FS", {
    "mountFiles": mountFiles,
  });


  const luaProgramState = {
    pause: false,
    debug: false,
    luaStateRef: null,
  };

  let luaStateEvent = () => {};

  function luaProgramDebugEnable(ctx) {
    luaProgramState.debug = true;
    console.log(">>>> DEBUGGER ACTIVATED <<<<");
    console.log(" --- binding dbg functions ---");
    console.log(" (*) dbgLocals (*) dbgEval (*) dbgQuit (*) ");
    console.dir(ctx.inf);
    console.dir(ctx.trace);
    console.dir(ctx.locals);

    window.dbgQuit = () => {
      window.D = undefined;
      window.dbgQuit = undefined;
      window.dbgLocals = undefined;
      window.dbgEval = undefined;
      for (let k in d.jsScope) {
        window[k] = undefined;
      }
      luaProgramState.debug = false;
    }
    window.dbgLocals = (i) => {
      console.dir(ctx.locals);
    }
    window.dbgEval = (ll) => {
      const res = ctx.eval(ll);
      console.dir(res);
    }
    window.D = d;
    for (let k in ctx.jsScope) {
      window[k] = ctx.jsScope[k];
    }
  }

  function bindLuaState(st, evfn) {
    console.log("lua state bound");
    luaProgramState.luaStateRef = st;
    luaStateEvent = evfn;
  }

  lua.global.set("prettyPrint", console.dir);

  lua.global.set("PROG", {
    bind: bindLuaState,
    debug: luaProgramDebugEnable,
    pause: () => { luaProgramState.pause = true; },
    unpause: () => { luaProgramState.pause = false; },
  });

  await lua.doString(`
    require"entry"
   `);

  const canvas = document.querySelector("#canvas");
  const drawContext = canvas.getContext("2d");

  let then = performance.now();
  const FPS = 5;
  const dFPS = 1 / FPS;
  let frameAcc = 0;

  function update(now) {
    window.requestAnimationFrame(update);
    if (luaProgramState.debug || luaProgramState.pause) {
      return;
    }
    let dt = (now - then) / 1000;
    then = now;
    frameAcc += dt;
    if (frameAcc > dFPS) {
      frameAcc = 0;
      luaStateEvent("update", dt)
      luaStateEvent("draw", dt, drawContext)
    }
  }

  update(then);

  window.onkeydown = (e) => {
    if (luaProgramState.debug) {
      return;
    }
    luaStateEvent("keydown", e.key)
  }

})();
