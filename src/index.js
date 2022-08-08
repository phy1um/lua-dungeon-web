
(async function() {
  const { LuaFactory } = require('wasmoon');

  const factory = new LuaFactory();

  async function mountFile(path) {
    return fetch(path)
      .then(res => res.text())
      .then(t => factory.mountFile(path, t))
      .catch(err => console.error(err));
  }

  await mountFile("./stuff.lua");

  const lua = await factory.createEngine();

   try {
      lua.global.set("NS", {
        "add": (x, y) => x+y,
      });
      lua.global.set("DOM", {
        "create": (n) => document.createElement(n),
        "query": (q) => document.querySelector(q),
      });
      await lua.doString(`
        print('running lua')
        local s = require"stuff"
        for i=0,10,1 do
          s("wow wow wow")
        end
        s(NS.add(1,2))
      `);
  } finally {
      lua.global.close();
  }
})();
