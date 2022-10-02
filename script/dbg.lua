
local dbg = {
  thread = nil
}

function dbg:b() 
  local thread = coroutine.running()
  local ctx = {}
  ctx.inf = debug.getinfo(thread, 2)
  ctx.trace = debug.traceback(thread)
  ctx.locals = {}
  local hasLocal = true
  local localIndex = 0
  while hasLocal == true do
    local name, val = debug.getlocal(1, localIndex)
    if name == nil then 
      hasLocal = false 
    else 
      print("found local")
      table.insert(ctx.locals, {name = name, value = value, index = localIndex})
      localIndex = localIndex + 1
    end
  end
  function ctx.eval(l)
    return load(l)
  end
  JSPROG.debugOn(ctx)
  coroutine.yield()
end

return dbg
