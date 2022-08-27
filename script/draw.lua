
local dd = {
  innerWidth = 12,
  innerHeight = 12,
  padX = 1,
  padY = 1,
  tilesPerRow = 50,
}

function dd.init(element)
  dd._spritesheet = DOM.query(element)
  if dd._spritesheet == nil then
    error("failed to load spritesheet " .. element)
  end
end

function dd.sprite(ctx, ind, x, y)
  local ix = ind % dd.tilesPerRow 
  local iy = math.floor(ind / dd.tilesPerRow)
  local pixelX = (dd.innerWidth + dd.padX) * ix
  local pixelY = (dd.innerHeight + dd.padY) * iy
  ctx.drawImage(
    dd._spritesheet,
    -- source
    pixelX + dd.padX, pixelY + dd.padY, dd.innerWidth, dd.innerHeight,
    -- dest
    x, y, dd.innerWidth, dd.innerHeight)
end

return dd
