function cenemy(x, y)
  local c = char("o", x, y)
  c.t = "Enemy"
  c.max_health = 100
  c.health = 100
  c.defense = 10
  c.power = 3
  c.attribute_table = { -- Used for drawing
    "HP: " .. c.health .. "/" .. c.max_health
  }
  return c
end

function enemy_update(e, i)
  e.attribute_table = {
    "HP: " .. e.health .. "/" .. e.max_health
  }
  if e.health <= 0 then
    enemy_die(e, i)
    return
  end
end

function enemy_draw(e)
  e:draw()
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.print(e.health, e.x*16, (e.y-1)*16)
  love.graphics.setColor(1, 1, 1, 1)
end

function enemy_turn(e, i)
  local dx, dy = player.x - e.x + math.rsign(), player.y - e.y + math.rsign()
  local dist = (dx^2+dy^2)^0.5
  
  if dist < 5 then
    dx, dy = math.round(dx/dist), math.round(dy/dist)
    if e.health <= 0 then
      enemy_die(e, i)
      return
    end
    if char_around(player, e.x, e.y) then
      player.health = player.health - 1
    end
    if e ~= nil then e:move(dx, dy) end
  end
end

function enemy_die(e, i)
  enemy_loot(e, i)
  enemies[i] = nil
end

function enemy_loot(e, i)
  
end

function enemy_nearest(x, y, max_distance)
  local dists = {}
  local is =  {}
  
  for i, enemy in pairs(enemies) do
    table.insert(dists, math.dist(x, y, enemy.x, enemy.y))
    is[math.dist(x, y, enemy.x, enemy.y)] = i
  end
  
  table.sort(dists)
  
  if dists[1] <= max_distance then
    return enemies[is[dists[1]]]
  else 
    return nil
  end
  
end

function enemies_in_area(x, y, distance)
  
  local in_area = {}
  
  for i, e in pairs(enemies) do
    if math.dist(x, y, e.x, e.y) <= distance then
      table.insert(in_area, {i, e})
    end
  end
  
  return in_area
end