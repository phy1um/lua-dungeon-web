local b64 = require"base64"
local draw = require"draw"

local world = {
  width = 0,
  height = 0,
  tiles = {},
  col = {},
}

function world:test(x, y)
  if x < 0 or x >= self.width or y < 0 or y >= self.height then
    return true
  end
  local ind = y*self.width + x
  if self.col[ind+1] > 0 then return true else return false end
end

function world:draw(ctx, xo, yo, w, h)
  for xx=0,w-1,1 do
    for yy=0,h-1,1 do
      local ind = (yo + yy)*self.width + xo + xx
      draw.sprite(ctx, self.tiles[ind+1] - 1, xx*12, yy*12)
    end
  end
end

local function findNamed(m, name)
  for k,v in pairs(m) do
    if v.name == name then
      return v
    end
  end
  return nil
end

local function decodeMap(w, h, data)
  local decoded = b64.decode(data)
  if #decoded % 4 ~= 0 then
    error("map data must have length = 0 (%4)")
  end
  local tiles = {}
  local decodedWordCount = math.floor(#decoded / 4)
  for i=0,decodedWordCount-1,1 do
    local iv0 = string.byte(decoded, i*4 + 1) 
    local iv1 = string.byte(decoded, i*4 + 2) 
    local iv2 = string.byte(decoded, i*4 + 3) 
    local iv3 = string.byte(decoded, i*4 + 4) 
    local iv = iv0 | (iv1 << 8) | (iv2 << 16) | (iv3 << 24)
    -- print("tile (" .. i .. ") = " .. iv)
    table.insert(tiles, iv)
  end
  return tiles
end

local function loadWorld(path)
  local mapData = require(path)
  local mapLayer = findNamed(mapData.layers, "map")
  local collisionLayer = findNamed(mapData.layers, "collision")
  local w = setmetatable({
    width = mapData.width,
    height = mapData.height,
    tiles = decodeMap(mapData.width, mapData.height, mapLayer.data),
    col = decodeMap(mapData.width, mapData.height, collisionLayer.data),
  }, { __index = world })
  return w
end

world.load = loadWorld

return world
