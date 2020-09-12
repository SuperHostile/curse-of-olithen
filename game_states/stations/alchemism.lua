-- why did i name this alchemism
new_game_state("alchemism_station", {
  load = function(data)
    gui_alchemism()
  end,
  update = function(data, dt)
    gui_update(gui)
  end,
  draw = function(data)
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
    gui_predraw(gui)
    love.graphics.pop()
  
    gui_draw(gui)
  end,
  keypressed = function(data, key)
    gui_keypressed(gui, key)
    --if key == "escape" then game_state = "playing" end
  end,
  mousepressed = function(data, x, y, button)
    gui_mousepressed(gui, x, y, button)
  end
})