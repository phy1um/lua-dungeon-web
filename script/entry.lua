
local DRAW = require"draw"
local WORLD = require"world"
local C = DOM.query("#container")
local xx = 0
local yy = 0
local W = 26
local H = 20

DRAW.init("#spritesheet")

local ww = WORLD.load("map1")

local function put(msg)
  local pp = DOM.create("p")
  pp.innerText = msg
  C.appendChild(pp)
end


function JSPROG.update(dt)
end

function JSPROG.draw(dt, ctx)
  ctx.clearRect(0, 0, 320, 240)
  ctx.fillStyle ="black"
  ctx.fillRect(0, 0, 320, 240)
  ww:draw(ctx, 0, 0, W, H)
  DRAW.sprite(ctx, 26, xx*12, yy*12)
end

function JSPROG.keydown(e)
  if e.key == "w" then yy = yy - 1
  elseif e.key == "a" then xx = xx - 1
  elseif e.key == "s" then yy = yy + 1
  elseif e.key == "d" then xx = xx + 1
  end
end

