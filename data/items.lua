data.items = {
  
  
  
  bronze_sword = {
    stats = {
      power = 5,
      durability = 100
    },
    use = {
      type = "equip"
    },
    unstackable = true,
  },
  
  
  ancestral_sword = {
    stats = {
      power = 7,
      durability = 100
    },
    use = {
      type = "equip"
    },
    unstackable = true,
  },
  
  
  
  olithen_battle_axe = {
    stats = {
      power = 25,
      durability = 10000
    },
    use = {
      type = "equip"
    },
    unstackable = true
  },
  basic_iron_ring = {
    stats = {
      power = 4
    },
    use = {
      type = "auxiliary",
      aux = "ring"
    },
    unstackable = true,
  },
  crystabell_plated_helmet = {
    stats = {
      defense = 10,
    },
    use = {
      type = "auxiliary",
      aux = "helmet"
    },
    unstackable = true,
  },
  
  
  
  scroll_lightning_bolt = {
    unstackable = true,
    stats = {
      power = 15,
      turns = 15
    },
    use = {
      type = "overtime",
      volatile = false,
      can = "lightning_bolt",
      on_use = function(p, index, item_data)
        
        local e = enemy_nearest(p.x, p.y, 10)
        --e.health = e.health - 100
        if e ~= nil then e.health = e.health - player_calculate_elemental_damage(p, "lightning", item_data.stats.power); p.can.lightning_bolt = false; return true end
        return false
      end,
      on_turn = function(p, index, item_data, duration)
        --player.health = player.health + item_data.stats.healing
      end,
      on_last_turn = function(p, index, item_data)
        p.can.lightning_bolt = true
      end
    },
  },
  
  
  scroll_fire_explosion = {
    unstackable = true,
    stats = {
      power = 10,
      turns = 10
    },
    use = {
      type = "overtime",
      volatile = false,
      can = "fire_explosion",
      on_use = function(p, index, item_data)
        p.can.fire_explosion = false
        local es = enemies_in_area(enemy_nearest(p.x, p.y, 100).x, enemy_nearest(p.x, p.y, 100).y, 10)
        for i, pair in pairs(es) do
          pair[2].health = pair[2].health - player_calculate_elemental_damage(p, "fire", (item_data.stats.power/2))
        end
      end,
      on_turn = function(p, index, item_data, duration)
        
      end,
      on_last_turn = function(p, index, item_data)
        p.can.fire_explosion = true
      end
    }
  },
  
  
  
  potion_healing = {
    stats = {
      healing = 10
    },
    use = {
      type = "heal",
      
    }
  },
  
  potion_regeneration = {
    stats = {
      healing = 2,
      turns   = 7
    },
    use = {
      type = "overtime",
      volatile = true,
      on_use = function(p, index, item_data)
        
      end,
      on_turn = function(p, index, item_data, duration)
        player.health = player.health + item_data.stats.healing
      end,
      on_last_turn = function(p, index, item_data)
      
      end
    }
  },
  
  potion_mana = {
    stats = {
      turns = 7,
      mana_healing = 1
    },
    use = {
      type = "overtime",
      volatile = true,
      on_turn = function(p, index, item_data, duration)
        player.mana = player.mana + item_data.stats.mana_healing
      end
    }
  },

  healing_herb = {
    material = true,
    rarity = 1,
  },
  bottle = {
    material = true,
    rarity = 1,
  }
}

-- Create the translation keys for every item
function items_update_translation()
  for i, v in pairs(data.items) do
    v.name = lang_create_key("items."..i).cached or "items."..i;
  end
end

items_update_translation();

function return_item(name, stats)
  local c = table.copy(data.items[name])
  c.stat_changes = table.copy(stats)
  c.id = name
  if c.stats then
    for i, stat in pairs(stats) do
      if c.stats[i] ~= nil then
        c.stats[i] = c.stats[i] + stat
      else
        c.stats[i] = stat
      end
    end
  else
    c.stats = {};
  end
  return c
end

function random_interval(min, max, t)
  return {
    min = min,
    max = max,
    type = t or "up",
    produce = function(self)
      return math.round(math.random(self.min, self.max))
    end
  }
end

item_pool = {
  { -- Dungeon item pool
    {"bronze_sword",
      {
        power = random_interval(-1, 3)
      },
      30
    },
    {"potion_healing",
      {
        healing = random_interval(0, 3)
      },
      50
    },
    {"potion_regeneration",
      {
        healing = random_interval(0, 1),
        turns   = random_interval(0, 1, "down")
      },
      20
    },
    {"scroll_lightning_bolt",
      {
        power   = random_interval(-2, 2),
        turns   = random_interval(0, -3, "down")
      },
      10
    },
    {"scroll_fire_explosion",
      {
        power = random_interval(0, 1),
        turns = random_interval(3, -2, "down")
      },
      10
      
    },
    {"basic_iron_ring",
      {
        power = random_interval(0, 2)
      },
      100
    },
    {"crystabell_plated_helmet",
      {
        defense = random_interval(-1, 5)
      },
      100
    },
    {"potion_mana",
      {
        mana_healing = random_interval(0, 1)
      },
      100
    },
    {"healing_herb",
      {

      },
      100
    }
  }, 
  { -- Starting item pool
    {
      "ancestral_sword",
      {
        power = random_interval(0, 2)
      },
      50
    },
    
  },
  { -- test pool
    {"healing_herb", {}, 1},
    {"potion_healing", {healing = random_interval(0, 3)}, 1}
  }
}

rarity_pool = {
  {
    "common",
    colors.gray,
    400
  }, {
    "uncommon",
    colors.green,
    200
  }, {
    "rare",
    colors.skyblue,
    200
  }, {
    "epic",
    colors.purple,
    100
  }, {
    "legendary",
    colors.goldenrod,
    75
  }, {
    "godly",
    colors.mediumvioletred,
    25
  }
}

-- Uses weighted randomness to return a rarity
function produce_rarity(index)
  local weights = {}
  local total_weight = 0
  
  -- Store all the weights
  for i, rarity in pairs(rarity_pool) do
    weights[i] = {rarity[3], i}
    total_weight = total_weight + rarity[3]
  end
  
  local rn = math.random(0, total_weight)
  local selected = 0
  
  -- Iterate trough all the weights.
  for i, weight in pairs(weights) do
    rn = rn - weight[1]
    if rn <= 0 then
      selected = i
      break
    end
  end
  
  local resulting_rarity = table.copy(rarity_pool[index] or rarity_pool[selected])
  resulting_rarity[4] = index or selected
  return resulting_rarity
end

-- Returns stat changes depending on the ones passed and the rarity
-- FIX : Make it sure to not get negative stats.
function produce_stat_changes(rarity, stat_changes)
  for index, interval in pairs(stat_changes) do
    if interval.type == "up" then
      interval.max = (interval.max * rarity[4]) + dungeon_level
      interval.min = dungeon_level
    elseif data.stats[index].upgradeable then
      interval.max = (interval.max * rarity[4]) - dungeon_level
    end
  end
  return stat_changes
end

-- Uses weighted randomness to return an item from a pool
function produce_item(pool, rarity, quantity)
  
  local weights = {}
  local total_weight = 0
  
  -- Store all the weights
  for i, item in pairs(item_pool[pool]) do
    weights[i] = {item[3], i}
    total_weight = total_weight + item[3]
  end
  
  local rn = math.random(0, total_weight)
  local selected = 0
  
  -- Iterate trough all the weights.
  for i, weight in pairs(weights) do
    rn = rn - weight[1]
    if rn <= 0 then
      selected = i
      break
    end
  end
  
  -- Calculate random stat intervals
  --print(item_pool[pool][selected][1]);
  local resulting_rarity = produce_rarity(rarity or data.items[ item_pool[pool][selected][1] ].rarity) -- Generate a rarity
  local stat_intervals = produce_stat_changes(resulting_rarity, table.copy(item_pool[pool][selected][2])) -- Generate stat intervals from rarity and defaults
  local resulting_stats = {}
  for name, interval in pairs(stat_intervals) do
    resulting_stats[name] = interval:produce() -- Resulting stats of the item
  end
  local resulting_item = return_item(item_pool[pool][selected][1], resulting_stats) -- Creates the item with the stats provided
  
  resulting_item.rarity = resulting_rarity -- Assigns the rarity to the item
  if resulting_item.unstackable then
    resulting_item.quantity = 1
  else
    resulting_item.quantity = quantity or math.round(math.random(1, 6))
  end
  
  resulting_item.is_material = data.items[ item_pool[pool][selected][1] ].material
  if resulting_item.is_material then
    resulting_item.dungeon_level = 0;
  else
    resulting_item.dungeon_level = dungeon_level
  end

  return resulting_item -- Returns the item
end

function item_can_stack(i1, i2)
  return (i1.id == i2.id) and (i1.dungeon_level == i2.dungeon_level)
end