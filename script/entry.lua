
local DRAW = require"draw"
local C = DOM.query("#container")
local xx = 0
local yy = 0
local W = 26
local H = 20

DRAW.init("#spritesheet")

local function makeMap(w, h)
  local mm = {}
  for i=1,w,1 do
    for j=1,h,1 do
      local ri = math.floor(math.random() * 5)
      table.insert(mm, ri)
    end
  end
  return mm
end

local MAP = makeMap(W, H)

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

  for i=1,W,1 do
    for j=1,H,1 do
      local ind = (j-1)*W + (i-1)     
      local mi = MAP[ind+1]
      if mi > 0 then
        DRAW.sprite(ctx, mi, (i-1)*12, (j-1)*12)
      end
    end
  end

  DRAW.sprite(ctx, 26, xx*12, yy*12)
end

function JSPROG.keydown(e)
  if e.key == "w" then yy = yy - 1
  elseif e.key == "a" then xx = xx - 1
  elseif e.key == "s" then yy = yy + 1
  elseif e.key == "d" then xx = xx + 1
  end
end

