
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
  "world",
  "game",
  "state",
}

function wrapCall(k)
  local dbg = require"dbg" 
  local n = "_w" .. k
  JSPROG[n] = function(...)
    print("running wrapped call " .. k)
    local f = JSPROG[k]
    if f == nil then return end
    local co = coroutine.create(f)
    if co == nil or type(co) ~= "thread" then
      print("invalid coro " .. k)
      return
    end
    local st, err = coroutine.resume(co, ...)
    if st == false then 
      print(err)
     return
    end
  end
end

local gameLogContainer = DOM.query("#gamelog")
function gameLog(msg)
  local pp = DOM.create("p")
  pp.innerText = msg
  gameLogContainer.prepend(pp)
end

local put = gameLog

function reloadAll()
  JSPROG.pause = true
  JSPROG.mountFiles(MOUNTS, function()
    for i, m in ipairs(MOUNTS) do
      reload(m)
    end
    local dd = require"draw"
    dd.init("#spritesheet")
    JSPROG.pause = false
  end)
end

JSPROG.mountFiles({"hot", "dbg"}, function()
  require, reload = require"hot".init()

  wrapCall("update")
  wrapCall("draw")
  wrapCall("keydown")

  JSPROG.mountFiles(MOUNTS, function()
    put("Lua dungeon test by Tom Marks (coding.tommarks.xyz)")
    put("WASD to move around")
    local G = require"game"
    local state = G.new("map1")
    state:bind()
  end)
end)

