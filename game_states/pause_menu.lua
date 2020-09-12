new_game_state("pause_menu", {
  update = function(data, dt)
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
    map_draw_pause(map)
    love.graphics.pop()
  end,
  keypressed = function(data, key)
    --if key == "escape" then game_state = "playing" end
    if key == "escape" then change_game_state("playing") end
  end
})