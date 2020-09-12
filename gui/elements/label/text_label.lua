function create_text_label(x, y, text, font)
  local te = love.graphics.newText(font, text)
  local ge = create_gui_element(
    x, y,
    te:getWidth(), te:getHeight(),
    {
      draw = function(self)
        love.graphics.setColor(colors.white)
        love.graphics.draw(self.text, self.x, self.y)
      end,
      update = function(self, dt, text)
        self.text = love.graphics.newText(self.font, text)
        self.text_string = text
        self.w = self.text:getWidth()
        self.h = self.text:getHeight()
      end
    }
  )
  ge.text = te
  ge.font = font
  ge.text_string = text
  return ge
end