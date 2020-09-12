function cstation(c, x, y, s_type)
  local st = char(c, x, y)
  st.t = "Station"
  st.s_type = s_type or "alchemism"
  st.index = #stations+1
  st.attribute_table = {
    "Alchemism"
  }
  
  return st
end

function station_draw(st)
  love.graphics.setColor(colors.white)
  love.graphics.print(st.c, st.x*16, st.y*16)
end