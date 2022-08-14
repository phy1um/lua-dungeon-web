local DRAW = require"draw"

local cam = {
  x = 0, y = 0, w = 0, h = 0,
  marginX = 0, marginY = 0,
  limitX = 0, limitY = 0,
}

function cam.new(x, y, w, h)
  return setmetatable({x = x, y = y, w = w, h = h}, {__index = cam})
end

function cam:limit(w, h)
  self.limitX = w - self.w - 1
  self.limitY = h - self.h - 1
end

function cam:margin(x, y)
  self.marginX = x
  self.marginY = y
end

function cam:follow(px, py)
  local sx = self.x
  local sy = self.y
  if (px - self.x) - self.w + self.marginX > 0 then self.x = self.x + 1 
  elseif px - self.x - self.marginX < 0 then self.x = self.x - 1 
  end
  if (py - self.y) - self.h + self.marginY > 0 then self.y = self.y + 1 
  elseif py - self.y - self.marginY < 0 then self.y = self.y - 1 
  end
  self.x = math.max(0, math.min(self.x, self.limitX))
  self.y = math.max(0, math.min(self.y, self.limitY))
end

function cam:drawWorld(ctx, world)
  world:draw(ctx, self.x, self.y, self.w, self.h)
end

function cam:drawSprite(ctx, index, sx, sy)
  DRAW.sprite(ctx, index, (sx - self.x)*12, (sy - self.y)*12)
end

return cam
