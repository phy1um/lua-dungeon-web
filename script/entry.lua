
local DRAW = require"draw"
local WORLD = require"world"
local C = DOM.query("#gamelog")
local xx = 0
local yy = 0
local W = 26
local H = 20

local function put(msg)
  local pp = DOM.create("p")
  pp.innerText = msg
  C.appendChild(pp)
end

local cam = {x = 0, y = 0, w = W, h = H, mx = 0, my = 0}
function cam:follow(px, py)
  -- TODO: cleanup magic numbers
  local sx = cam.x
  local sy = cam.y
  if (px - self.x) - self.w + 6 > 0 then self.x = self.x + 1 
  elseif px - self.x - 6 < 0 then self.x = self.x - 1 
  end
  if (py - self.y) - self.h + 4 > 0 then self.y = self.y + 1 
  elseif py - self.y - 4 < 0 then self.y = self.y - 1 
  end
  self.x = math.max(0, math.min(self.x, self.mx))
  self.y = math.max(0, math.min(self.y, self.my))

  if self.x ~= sx or self.y ~= sy then
    put("camera move: (" .. cam.x .. ", " .. cam.y .. ")")
  end
end

DRAW.init("#spritesheet")

local ww = WORLD.load("map1")
cam.mx = ww.width - cam.w - 1
cam.my = ww.height - cam.h - 1


function JSPROG.update(dt)
end

function JSPROG.draw(dt, ctx)
  ctx.clearRect(0, 0, 320, 240)
  ctx.fillStyle ="black"
  ctx.fillRect(0, 0, 320, 240)

  ww:draw(ctx, cam.x, cam.y, W, H)
  DRAW.sprite(ctx, 26, (xx - cam.x)*12, (yy - cam.y)*12)
  cam:follow(xx, yy)
end

function JSPROG.keydown(e)
  if e.key == "w" then yy = yy - 1
  elseif e.key == "a" then xx = xx - 1
  elseif e.key == "s" then yy = yy + 1
  elseif e.key == "d" then xx = xx + 1
  elseif e.key == "p" then JSPROG.pause = not JSPROG.pause
  end
end

put("Lua dungeon test by Tom Marks (coding.tommarks.xyz)")
put("WASD to move around")
