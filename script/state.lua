
local baseState = {}

function baseState:update() end
function baseState:draw() end
function baseState:keydown() end
function baseState:runEvent(ev, ...) 
  print("STATE RUN EVENT: " .. ev .. ":: " .. tostring(...))
  local fn = self[ev] 
  if fn == nil then
    error("no such state event " .. ev)
  end
  local co = coroutine.create(fn)
  if co == nil or type(co) ~= "thread" then
    error("invalid coro " .. tostring(co))
  end
  print("CORO: START")
  local st, err = coroutine.resume(co, self, ...)
  print("CORO: END")
  if st == false then 
    error(err)
  end 
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

