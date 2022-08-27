
local baseState = {}

function baseState:update() end
function baseState:draw() end
function baseState:keydown() end

function baseState:bind()
  JSPROG.update = function(dt) self:update(dt) end
  JSPROG.draw = function(dt, ctx) self:draw(dt, ctx) end
  JSPROG.keydown = function(e) self:keydown(e.key) end
end

function baseState.extend(o)
  for k, v in pairs(baseState) do
    if o[k] == nil then 
      o[k] = baseState[k] 
    end
  end
  return o
end

return baseState

