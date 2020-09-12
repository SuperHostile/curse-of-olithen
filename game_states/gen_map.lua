new_game_state("gen_map", {
  load = function(data)
    
  end,
  update = function(data, dt)
    ticker:tick(gen_stage, gen_map_ticks[gen_stage])
  end,
  draw = function(data)
    love.graphics.print(gen_stage, 0, 0)
    love.graphics.print(100-((100/ticker:get_start_tick(gen_stage))*ticker:get_tick(gen_stage)), 0, 32)
  end
})