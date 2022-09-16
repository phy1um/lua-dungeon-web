
local function isBreakpoint(fname, line)
  for i, bp in ipairs(JSPROG.breakpoints) do
    if bp.file == fname and bp.line == line then
      return true
    end
  end
  return false
end

local dbg = {
  hook = defaultDbgHook
}

function dbg.new(o)
  for k, v in pairs(dbg) do
    if o[k] == nil then o[k] = dbg[k] end
  end
  o.jsScope = {}
  return o
end

function dbg.locals(level)
  level = level + 1 -- the function that called this one
  local i = 1
  local out = {}
  while true do
    local k, v = debug.getlocal(level, i)
    if not name then break end
    out[k] = v
    i = i + 1
  end
  return out
end

function dbg.hook(event, line)
  if event ~= "line" then return end
  local fname = debug.getinfo(2, "n").name
  print(fname)
  if not isBreakpoint(fname, line) then return end
  JSPROG.debug(d) 
end

function dbg.stepHook(event, line)
  JSPROG.debug(d)
end


function dbg:bind()
  debug.sethook(self.hook, "l")
end

function dbg:bindStep()
  debug.sethook(self.stepHook, "l", 1)
end

return dbg
