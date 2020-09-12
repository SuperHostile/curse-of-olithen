function create_colored_text_label(x, y, text, font,color)
  local ge = create_text_label(x, y, text, font)
  ge.color = color
  ge.draw = function(self)
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, self.x, self.y)
    love.graphics.setColor(r,g,b,a)
  end
  return ge
end