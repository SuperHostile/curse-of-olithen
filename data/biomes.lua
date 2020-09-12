data.biomes = {
  dungeon = {
    color = colors.white,
    weight = 1
  },
  plains = {
    color = colors.green,
    weight = 1
  },
  desert = {
    color = colors.goldenrod,
    weight = 1
  },
  cursed_woods = {
    color = colors.sandybrown,
    weight = 1
  },
  ["nil"] = {
    color = colors.black,
    weight = 0
  }
}

-- Update all the biomes' names
function biomes_update_translation()
  for i, v in pairs(data.biomes) do
    v.name = lang_create_key("biomes."..i).cached or "biomes."..i;
  end
end

biomes_update_translation();

function produce_biome()
  --[[local mt = math.round(math.random(0, 1))
  
  local bi
  if mt == 0 then
    bi = "dungeon"
  else
    bi = "plains"
  end
  
  return bi]]
  
  local weights = {}
  local total_weight = 0
  
  -- Store all the weights
  for i, item in pairs(data.biomes) do
    weights[i] = {item.weight, i}
    total_weight = total_weight + item.weight
  end
  
  local rn = math.random(0, total_weight)
  local selected = "plains"
  
  -- Iterate trough all the weights.
  for i, weight in pairs(weights) do
    rn = rn - weight[1]
    if rn <= 0 then
      selected = i
      break
    end
  end

  return selected
  
end