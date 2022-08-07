
(async function() {
  const { LuaFactory } = require('wasmoon');

  const factory = new LuaFactory();
  const lua = await factory.createEngine();

  function putLineOnScreen(t) {
    const x = document.querySelector("#container");
    const p = document.createElement("p");
    p.innerText = t;
    x.appendChild(p);
  }

  function netRequire(moduleName, path) {
    const res = fetch(`./${path}.lua`)
      .then(res => res.text())
      .then(t => lua.doString(t))
      .then(luaObj => lua.global.set(moduleName, luaObj))
      .catch(err => {
        console.error(err)
      });
  }

  try {
      lua.global.set("NS", {
        "put": putLineOnScreen,
        "add": (x, y) => x+y,
      });
      await lua.doString(`
        print('running lua')
        local s = netrequire"stuff"
        for i=0,10,1 do
          NS.put("wow wow wow")
        end
        NS.put(NS.add(1,2))
      `);
  } finally {
      lua.global.close();
  }
})();
