MAX_INVENTORY_ITEMS = 40

-- TODO : MAKE INVENTORY STACKING FOR CRAFTING ITEMS

--[[
  Controls:
    q w e
    a   s -> Movement in 8 directions
    z x c
    
    s -> Back or menu change
    u -> Use on item menu
    d -> Discard on item menu
]]

function cplayer(x, y)
  local player = char("@", x, y)
  player.prot = char()
  player.move = function(self, dx, dy)
    local move, move_table = player.prot.move(player, dx, dy)
    if move then
      player_calculate_fov(player)
      global_enemy_turn()
      return true
      -- Something is in the way of moving.
    else
      -- If the collision is with an enemy, attack
      if move_table.type == "Enemy" then
        move_table.other.health = move_table.other.health - player_calculate_damage(player)
        global_enemy_turn()
        return true
        --player_end_turn()
      elseif move_table.type == "Item" then
        --table.insert()
        if player_give_item(move_table.other.item) then -- Give the player a random item from pool 1
          item_delete(move_table.other.index)
        end
        return false
      end
      
      -- If the collision is a station, open the GUI
      if move_table.type == "Station" then
        change_game_state("alchemism_station")
      end
    end
  end
  --[[
    Inventory is an array of instantiated items from the produce_item
    function.
    
    Those results are of this form:
      quantity -> How much of this items is in the slot
      id -> Name of how the item is recognized in game
      dungeon_level -> The level of the dungeon the item was obtained in
      stats -> All of the stats of the item
      stat_changes -> The stat variations the item has gotten
      rarity -> Instantiated from the produce_rarity function
        name
        color of the rarity
        weight 
        index of the rarity in the data array
  ]]
  player.inventory = {}
  player.effects = {
    
  }
  player.can = {
    
  }
  player.elements = {
    lightning = 10,
    fire = 5,
    water = 5,
    air = 5,
    earth = 5,
    light = 5,
    darkness = 5
  }
  --player.equipped_weapon = return_item("bronze_sword", {power = 2})
  player.equipped_weapon = produce_item(2, 6) -- Produce an item from the second pool with godly rarity.
  player.equipped = {
    helmet = player_equipped_slot(),
    chestplate = player_equipped_slot(),
    leggings = player_equipped_slot(),
    boots = player_equipped_slot(),
    gloves = player_equipped_slot(),
    ring = player_equipped_slot(),
    necklace = player_equipped_slot()
  } -- The equipped slots lol
  player.health = 10
  player.max_health = 10000
  player.mana = 10
  player.max_mana = 100
  player.t = "Player"
  player.view_dist = 5
  player.class = "druidic warrior"
  
  for i = 1, MAX_INVENTORY_ITEMS do
    --[[table.insert(player.inventory, produce_item(1))
    for j, v in pairs(player.inventory[i]) do
    end]]
  end
  
  return player
end

function player_calculate_damage(p)
  return (
    player_get_stat_calculated("power")
  )
end

function player_calculate_elemental_damage(p, element, power)
  return p.elements[element]*(power/2)
end

function player_use_item(p, index, item_data)
  
  -- TODO : Volatile sometimes crashes the game
  --if item_data.use.volatile then local volatile = true else local volatile = false end
  local volatile = false
  if item_data.use.volatile ~= nil then
    volatile = item_data.use.volatile
  else
    volatile = true
  end
  
  
  local can = p.can[item_data.use.can]
  if can == nil then can = true end
  
  if not can then return end
  
  if item_data.use.type == "heal" then
    if p.health ~= p.max_health then
      p.health = math.min(p.max_health, p.health + item_data.stats.healing)
    end
  elseif item_data.use.type == "overtime" then
    local on_use = item_data.use.on_use or function() end
    on_use(p, index, item_data)
    player_add_effect("", item_data.stats.turns, item_data.use.on_turn or function() end, item_data, index, item_data.use.on_last_turn or function() end)
  elseif item_data.use.type == "equip" then
    table.insert(p.inventory, table.copy(p.equipped_weapon))
    p.equipped_weapon = table.copy(item_data)
    table.remove(p.inventory, index)
  elseif item_data.use.type == "auxiliary" then
    local item_slot = item_data.use.aux
    item_data.full = true
    if not p.equipped[item_slot].full then
      p.equipped[item_slot] = table.copy(item_data)
    else
      p.equipped[item_slot].full = false
      table.insert(p.inventory, table.copy(p.equipped[item_slot]))
      p.equipped[item_slot] = table.copy(item_data)
    end
    table.remove(p.inventory, index)
    
  end

  if not p.inventory[index].unstackable then 
    p.inventory[index].quantity = p.inventory[index].quantity - 1 
  end
  if p.inventory[index].quantity <= 0 and not p.inventory[index].unstackable and volatile then
    table.remove(p.inventory, index)
  end
end

function player_update(p)
  
  p.view_zone = {
      x = (
        (player.x*16)-(16*22)/(CAMERA_SCALE/2)
      ),
      y = (
        (player.y*16)-(16*13)/(CAMERA_SCALE/2)
      ),
      w = ( -- -(gui.panel_stats.w/(CAMERA_SCALE*2))
        (43*16/CAMERA_SCALE)*2
      ),
      h = ( -- -(gui.panel_messages.h/(CAMERA_SCALE*2))
        (24*16/CAMERA_SCALE)*2
      )
    }
    
  p.view_zone_pause = {
      x = (
        (player.x*16)-(16*22)/(CAMERA_SCALE/2)
      ),
      y = (
        (player.y*16)-(16*13)/(CAMERA_SCALE/2)
      ),
      w = ( -- -(gui.panel_stats.w/(CAMERA_SCALE*2))
        (52*16/CAMERA_SCALE)*2
      ),
      h = ( -- -(gui.panel_messages.h/(CAMERA_SCALE*2))
        (30*16/CAMERA_SCALE)*2
      )
    }
  if p.health <= 0 then
    --player_show_game_over(p)
    --player = nil
  end
  if p.x == stairs_x-1 and p.y == stairs_y-1 then
    next_level()
  end
  p.health = math.min(p.health, p.max_health)
  p.mana = math.min(p.mana, p.max_mana)
end

-- TODO : Change this to real fov lol
function player_calculate_fov(p)
  for x, v in ipairs(map) do
    for y, tile in ipairs(v) do
      if math.dist(p.x+0.5, p.y+0.5, x-0.5, y-0.5) < p.view_dist then
        tile.explored = true
      end
    end
  end
end

function player_keypressed(p, key)
  -- Cardinal directions
  --[[if key == "kp6" then p:move(1, 0) end
  if key == "kp4" then p:move(-1, 0) end
  if key == "kp2" then p:move(0, 1) end
  if key == "kp8" then p:move(0, -1) end]]
  
  -- Secondary cardinal controls
  if key == "right" then if p:move(1, 0) then player_turn() end end
  if key == "left" then if p:move(-1, 0) then player_turn() end end
  if key == "down" then if p:move(0, 1) then player_turn() end end
  if key == "up" then if p:move(0, -1) then player_turn() end end

  -- Diagonal directions
  --[[if key == "kp7" then p:move(-1, -1) end
  if key == "kp9" then p:move(1, -1) end
  if key == "kp1" then p:move(-1, 1) end
  if key == "kp3" then p:move(1, 1) end]]
  
  if key == "q" then if p:move(-1, -1) then player_turn() end end
  if key == "e" then if p:move(1, -1) then player_turn() end end
  if key == "z" then if p:move(-1, 1) then player_turn() end end
  if key == "c" then if p:move(1, 1) then player_turn() end end
  
  if key == "d" then if p:move(1, 0) then player_turn() end end
  if key == "a" then if p:move(-1, 0) then player_turn() end end
  if key == "x" then if p:move(0, 1) then player_turn() end end
  if key == "w" then if p:move(0, -1) then player_turn() end end
  
  if key == "space" then 
    for x, v in ipairs(map) do
      for y, node in ipairs(v) do
        node.explored = true
      end
    end
  end
  
  if key == "w" then
    --print_message("You hear a whisper from behind...", colors.snow)
  end
  
  if key == "s" then
    --print_message("You feel something behind you...", colors.darkblue)
  end
  if key == "l" then next_level() end
  if key == "o" then 
    for i = 1, MAX_INVENTORY_ITEMS do
      --table.insert(player.inventory, produce_item(1))
      player_give_item(produce_item(3))
      --[[for j, v in pairs(player.inventory[i]) do
      end]]
    end
  end
end

function player_draw(p)
  --love.graphics.print(p.c, p.x*16, p.y*16)
  --love.graphics.scale()
  p:draw()
  love.graphics.setColor(0, 1, 0, 1)
  --love.graphics.print(player.health .. "/" .. player.max_health, 0, 0)
  love.graphics.setColor(1, 1, 1, 1)
end

function player_show_game_over(p)
  
end
-- TODO : Item stacking maybe plox
function player_give_item(i)
  if #player.inventory >= MAX_INVENTORY_ITEMS and i.unstackable then
    print_message(lang_get_url_translation("gui.inventory.full_inventory"), colors.white)
    return false
  else
   if i.unstackable then
      print_message(lang_get_url_translation("gui.inventory.pick_up") .. i.name .. "!", colors.white)
      table.insert(player.inventory, i)
    else
      print_message(lang_get_url_translation("gui.inventory.pick_up") .. i.quantity .. "x " .. i.name .. "!", colors.white)
      local d = true;
      for it, v in ipairs(player.inventory) do
        if item_can_stack(i, v) then
          v.quantity = v.quantity + i.quantity;
          d = false
        end
      end
      if d then
        table.insert(player.inventory, i)
      end
    end
    
    return true
  end
end

function player_turn()
  for i, effect in pairs(player.effects) do
    effect.func(player, effect.index, effect.item, effect.duration)
    effect.duration = effect.duration - 1
    if effect.duration <= 0 then
      effect.last_turn_func(player, effect.index, effect.item_data)
      table.remove(player.effects, i)
    end
  end
end

-- TODO : Draw effects in GUI
function player_add_effect(name, duration, func, item, index, last_turn_func)
  table.insert(player.effects, {
    name = name or "Default",
    duration = duration or 5,
    func = func or function() end,
    item = item or {},
    index = index or 1,
    last_turn_func = last_turn_func or function() end
  })
end


function player_can_see(x, y)
  
  return math.point(
    {
      x = (x-1)*16,
      y = (y-1)*16
    },
    player.view_zone
  )
end

function player_can_see_pause(x, y)
  return math.point(
    {
      x = (x-1)*16,
      y = (y-1)*16
    },
    player.view_zone_pause
  )
end

-- Equipped slots
function player_equipped_slot()
  local t = {
    full = false
  }
  
  return t
end

function player_get_stat_calculated(stat)
  --[[player.equipped_weapon = produce_item(2, 6) -- Produce an item from the second pool with godly rarity.
  player.equipped = {
    helmet = player_equipped_slot(),
    chestplate = player_equipped_slot(),
    leggings = player_equipped_slot(),
    boots = player_equipped_slot(),
    gloves = player_equipped_slot(),
    ring = player_equipped_slot(),
    necklace = player_equipped_slot()
  }]]
  local equipped_dmg
  if player.equipped_weapon.stats[stat] ~= nil then
    equipped_dmg = player.equipped_weapon.stats[stat]
  else
    equipped_dmg = 0
  end
  
  for i, v in pairs(player.equipped) do
    if v.stats ~= nil then
    if v.stats[stat] ~= nil then
      equipped_dmg = v.stats[stat] + equipped_dmg
    end
    end
  end
  
  return equipped_dmg
  
end