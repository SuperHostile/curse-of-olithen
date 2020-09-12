function create_bar(x, y, value, max_value, total_width, bar_color, back_color, name)
  local ge = create_gui_element(
    x, y,
    total_width, 16,
    {
      draw = function(self)
        local bar_width = math.round(self.value / self.max_value * self.total_width)
        
        love.graphics.setColor(self.back_color)
        love.graphics.rectangle("fill", self.x, self.y, self.total_width, 16)
  
        love.graphics.setColor(self.bar_color)
        if bar_width > 0 then
          love.graphics.rectangle("fill", self.x, self.y, bar_width, 16)
        end
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(self.name .. ":" .. tostring(self.value) .. "/" .. tostring(self.max_value), self.x, self.y, 1000)
      end,
      update = function(self, dt, value, max_value)
        self.value = value
        self.max_value = max_value
      end
    }
  )
  ge.value = value
  ge.max_value = max_value
  ge.total_width = total_width
  ge.bar_color = bar_color
  ge.back_color = back_color
  ge.name = name
  return ge
end