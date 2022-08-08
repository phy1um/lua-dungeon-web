
return function(msg) 
  local x = DOM.query("#container")
  local pp = DOM.create("p")
  pp.innerText = msg
  x.appendChild(pp)
end

