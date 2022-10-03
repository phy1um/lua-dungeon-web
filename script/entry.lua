
VIEW_WIDTH = 26
VIEW_HEIGHT = 20

MOUNTS = {
  "base64",
  "camera",
  "draw",
  "entry",
  "map1",
  "stuff",
  "world",
  "game",
  "state",
}

local gameLogContainer = DOM.query("#gamelog")
function gameLog(msg)
  local pp = DOM.create("p")
  pp.innerText = msg
  gameLogContainer.prepend(pp)
end

local put = gameLog

function reloadAll()
  PROG.pause()
  FS.mountFiles(MOUNTS, function()
    for i, m in ipairs(MOUNTS) do
      reload(m)
    end
    local dd = require"draw"
    dd.init("#spritesheet")
    PROG.unpause()
  end)
end

FS.mountFiles({"hot", "dbg"}, function()
  require, reload = require"hot".init()
  FS.mountFiles(MOUNTS, function()
    put("Lua dungeon test by Tom Marks (coding.tommarks.xyz)")
    put("WASD to move around")
    local G = require"game"
    local state = G.new("map1")
    PROG.bind(state, function(...) 
      state:runEvent(...)
    end)
  end)
end)

