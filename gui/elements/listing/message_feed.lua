function create_message_feed(x, y, msgs)
  local ge = create_gui_element(x, y, gui.panel_messages.w, gui.panel_messages.h, {
    messages = msgs or {},
    load = function(self)
        self.messages = table.copy(messages_in_feed)
    end,
    draw = function(self)
      for i, v in pairs(self.messages) do
        
        for i, v in pairs(self.messages) do
          love.graphics.setColor(v.color or colors.white)
          love.graphics.printf(v.msg, 0, self.y+(i*16), 2500, "left", 0, 1, 1)
        end
        love.graphics.setColor(colors.white)
      end
    end,
    print_message = function(self, msg, col)
      table.insert(self.messages, {msg=msg, color=col})
      table.insert(messages_in_feed, {msg=msg, color=col})
      
      if #self.messages >= MAX_MESSAGES then
        table.remove(self.messages, 1)
      end
        
      if #messages_in_feed >= MAX_MESSAGES then
        table.remove(messages_in_feed, 1)
      end
    end,
    on_removed = function(self)
      messages_in_feed = table.copy(self.messages)
    end
  })
  return ge
end