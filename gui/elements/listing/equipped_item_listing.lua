function create_equipped_item_listing(x, y, w, h)
  local ge = create_gui_element(
    x, y, w, h, {
      draw = function(self)
        local ix, iy = self.x/16, 0
        for i, item in pairs(get_player().equipped) do
          if item.full then 
            love.graphics.setColor(item.rarity[2])
            love.graphics.print(
              data.items[item.id].name .. " +" .. item.dungeon_level, 
              ix*16,
              ( (self.y/16) +iy)*16+4
            )
          else
            love.graphics.setColor(colors.darkred)
            love.graphics.print(
              lang_get_url_translation("gui.empty_slot"), ix*16,
              ( (self.y/16) +iy)*16+4
            )
          end
          iy = iy + 1
        end
      end
    }
  )
  return ge
end