function create_panel(x, y, w, h)
  return create_gui_element(
    x, y, w, h, {
      draw = function(self)
        love.graphics.setColor(colors.panel)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
        love.graphics.setColor(1, 1, 1, 1)
      end
    }
  )
end