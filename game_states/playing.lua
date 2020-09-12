new_game_state("playing", {
  load = function(data)
    gui_playing()
  end,
  update = function(data, dt)
    gui_update(gui)
    player_update(player)
    for i, enemy in pairs(enemies) do
      enemy_update(enemy, i)
    end
  end,
  draw = function(data)
    playing_state_draw(data)
  end,
  keypressed = function(data, key)
    player_keypressed(player, key)
    gui_keypressed(gui, key)
    if key == "h" then CAMERA_SCALE = CAMERA_SCALE*2 end
    if key == "n" then CAMERA_SCALE = CAMERA_SCALE/2 end
    if key == "escape" then game_state = "pause_menu" end
  end,
  mousepressed = function(data, x, y, button)
    gui_mousepressed(gui, x, y, button)
  end
})

function playing_state_draw(data)
  love.graphics.push()
  love.graphics.scale(CAMERA_SCALE, CAMERA_SCALE)
  love.graphics.translate(
    (
      -(player.x*16)+
      (love.graphics.getWidth()/(CAMERA_SCALE*2)+8)-
      (gui.panel_stats.w/(CAMERA_SCALE*2))-4
    ), 
    (
      -(player.y*16)+
      (love.graphics.getHeight()/(CAMERA_SCALE*2)+8)-
      (gui.panel_messages.h/(CAMERA_SCALE*2))-4
    )
  )
  map_draw(map)
  player_draw(player)
  for i, enemy in pairs(enemies) do
    enemy_draw(enemy)
  end
  
  for i, item in pairs(items) do
    item_draw(item)
  end
    
    for i, station in pairs(stations) do
      station_draw(station)
    end
    gui_predraw(gui)
    love.graphics.pop()
  
    gui_draw(gui)
end