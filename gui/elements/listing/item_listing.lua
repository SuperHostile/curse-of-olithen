function create_item_listing(x, y, w, h, item, item_index)
  local ge = create_gui_element(
    x, y, w, h,
    {
      item_index = 0,
      item = item,
      draw = function(self)
        if self.item == nil then return end
        love.graphics.setColor(self.item.rarity[2])
        if self.item.unstackable then
          love.graphics.print(
            self.item.name .. " +" 
            .. self.item.dungeon_level, self.x+4, self.y+4
          )
        else
          love.graphics.print(self.item.quantity .. "x " .. 
            self.item.name .. " +" 
            .. self.item.dungeon_level, self.x+4, self.y+4
          )
        end
      
        local y_count = 1
        for i, v in pairs(self.item.stats) do
          love.graphics.setColor(data.stats[i].color)
          local stat_text = love.graphics.newText(
            love.graphics.getFont(),
            data.stats[i].name .. ": " .. v
          )
          --love.graphics.print(data.stats[i].name .. ": " .. v)
          love.graphics.draw(stat_text, self.x+4, (y_count*16)+self.y+4)
          if self.item.stat_changes[i] ~= nil then
            if self.item.stat_changes[i] >= 0 then
              love.graphics.setColor(data.stats[i].color)
              love.graphics.print(
                "+" .. (self.item.stat_changes[i]), 
                self.x+4+stat_text:getWidth()+16, 
                (y_count)*16+4+self.y
              )
            else
              love.graphics.setColor(data.stats[i].color)
              love.graphics.print(
                (self.item.stat_changes[i]), 
                stat_text:getWidth()+16, 
                (y_count)*16+4+self.y
              )
            end
          end
          y_count = y_count + 1
        end
        --y_count = 0
      end
    }
  )
  return ge
end