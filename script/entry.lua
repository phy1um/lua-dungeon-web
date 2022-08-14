local DRAW = require"draw"
local WORLD = require"world"
local CAMERA = require"camera"
local C = DOM.query("#gamelog")
local xx = 0
local yy = 0
local W = 26
local H = 20

function put(msg)
  local pp = DOM.create("p")
  pp.innerText = msg
  C.prepend(pp)
end

DRAW.init("#spritesheet")

local ww = WORLD.load("map1")
local cam = CAMERA.new(0, 0, W, H)
cam:limit(ww.width, ww.height)
cam:margin(10, 9)

local acc = 0
function JSPROG.update(dt)
  acc = acc + dt
  if acc > 10 then
    put("ping")
    acc = 0
  end
end

function JSPROG.draw(dt, ctx)
  ctx.clearRect(0, 0, 320, 240)
  ctx.fillStyle ="black"
  ctx.fillRect(0, 0, 320, 240)

  cam:drawWorld(ctx, ww)
  cam:drawSprite(ctx, 26, xx, yy)
  cam:follow(xx, yy)
end

function JSPROG.keydown(e)
  local dx = xx
  local dy = yy
  if e.key == "w" then dy = yy - 1
  elseif e.key == "a" then dx = xx - 1
  elseif e.key == "s" then dy = yy + 1
  elseif e.key == "d" then dx = xx + 1
  elseif e.key == "p" then JSPROG.pause = not JSPROG.pause
  end

  if ww:test(dx, dy) == false then
    xx = dx
    yy = dy
  end

end

put("Lua dungeon test by Tom Marks (coding.tommarks.xyz)")
put("WASD to move around")
