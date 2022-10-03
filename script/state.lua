
local baseState = {}

function baseState:update() end
function baseState:draw() end
function baseState:keydown() end
function baseState:runEvent(ev, ...) 
  print("go go " .. ev)
  local fn = function() print("?") end
  if ev == "draw" then
    fn = draw
  else
    fn = update
  end
  if fn == nil then
    error("even func was nil?")
  end
  local co = coroutine.create(fn)
  coroutine.resume(co, self, ...)
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

