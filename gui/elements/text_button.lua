function create_text_button(x, y, text, font, color, on_pressed, on_released, key)
  local te = love.graphics.newText(font, text)
  local ge = create_gui_element(
    x, y,
    te:getWidth(), te:getHeight(),
    {
      draw = function(self)
        love.graphics.setColor(self.color)
        love.graphics.draw(self.text, self.x, self.y)
      end,
      update = function(self, dt, text)
        self.text = love.graphics.newText(self.font, text)
        self.text_string = text
        self.w = self.text:getWidth()
        self.h = self.text:getHeight()
      end,
      mousepressed = function(self, x, y, button)
        if math.point(
          {
            x = x,
            y = y,
          }, {
            x = self.x,
            y = self.y,
            w = self.w,
            h = self.h
          }
        ) and button == 1 then
          self:on_pressed(x, y, button)
        end
      end,
      keypressed = function(self, key)
        if key == self.key then self:on_pressed(0, 0, 1) end
      end,
      on_pressed = on_pressed or function(self, x, y, button) end,
      on_released = on_released or function() end
    }
  )
  ge.text = te
  ge.font = font
  ge.text_string = text
  ge.color = color
  ge.key = key
  return ge 
end