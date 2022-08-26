
VIEW_WIDTH = 26
VIEW_HEIGHT = 20

MOUNTS = {
  "base64",
  "camera",
  "draw",
  "entry",
  "main",
  "map1",
  "stuff",
  "test",
  "world",
  "game",
  "state",
}

function reloadAll()
  JSPROG.pause = true
  JSPROG.mountFiles(MOUNTS, function()
    for i, m in ipairs(MOUNTS) do
      reload(m)
    end
    local dd = require"draw"
    prettyPrint(dd)
    --JSPROG.pause = false
  end)
end

JSPROG.mountFiles({"hot"}, function()
  require, reload = require"hot".init()
  JSPROG.mountFiles(MOUNTS, function()
    local G = require"game"
    local state = G.new("map1")
    state:bind()
  end)
end)

