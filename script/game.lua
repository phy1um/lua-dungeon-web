local DRAW = require"draw"
local WORLD = require"world"
local CAMERA = require"camera"
local STATE = require"state"
local dbg = require"dbg"

local game = STATE.extend{
  world = nil,
  px = 0,
  py = 0,
  pauseNext = false,
}

function game.new(m)
  local o = setmetatable({}, {__index = game})
  o:init(m)
  prettyPrint(o)
  return o
end

function game:init(m)
  DRAW.init("#spritesheet")
  self.world = WORLD.load(m)
  self.cam = CAMERA.new(0, 0, VIEW_WIDTH, VIEW_HEIGHT)
  self.cam:limit(self.world.width, self.world.height)
  self.cam:margin(10, 9)
end

function game:update()
  if self.pauseNext == true then
    JSPROG.pause = true
    self.pauseNext = false
  end
end

function game:draw(dt, ctx)
  ctx.clearRect(0, 0, 320, 240)
  ctx.fillStyle = "black"
  ctx.fillRect(0, 0, 320, 240)

  self.cam:drawWorld(ctx, self.world)
  self.cam:drawSprite(ctx, 26, self.px, self.py)
  self.cam:follow(self.px, self.py)
end

function game:keydown(k)
  local dx = 0
  local dy = 0 
  if k == "w" then dy = -1
  elseif k == "a" then dx = -1
  elseif k == "s" then dy = 1
  elseif k == "d" then dx = 1
  elseif k == "p" then JSPROG.pause = not JSPROG.pause
  elseif k == "z" then dbg.b()
  elseif k == "." then 
    JSPROG.pause = false
    self.pauseNext = true
  elseif k == "0" then 
    reloadAll()
  end

  if self.world:test(self.px + dx, self.py + dy) == false then
    self.px = self.px + dx
    self.py = self.py + dy
  end
end

return game
