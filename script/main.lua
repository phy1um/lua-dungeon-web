local C = DOM.query("#gamelog")
VIEW_WIDTH = 26
VIEW_HEIGHT = 20

function put(msg)
  local pp = DOM.create("p")
  pp.innerText = msg
  C.prepend(pp)
end

function JSPROG.update(dt)
end

function JSPROG.draw(dt, ctx)
end

function JSPROG.keydown(e)
end

put("Lua dungeon test by Tom Marks (coding.tommarks.xyz)")
put("WASD to move around")

