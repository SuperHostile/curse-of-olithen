function create_inventory_listing(x, y, w, h)
  local ge = create_gui_element(
    x, y, w, h, {
      draw = function(self)
        local ix, iy = 0, 0
        for i, item in pairs(get_player().inventory) do
          love.graphics.setColor(item.rarity[2])
          if data.items[item.id].material then
            love.graphics.print(item.quantity .. "x " .. data.items[item.id].name, ix*16, ((self.y/16)+iy)*16+4)
          else
            love.graphics.print(item.quantity .. "x " .. data.items[item.id].name .. " +" .. item.dungeon_level, ix*16, ((self.y/16)+iy)*16+4)
          end
          iy = iy + 1
          if iy >= 10 then
            iy = 0
            ix = (i*2)
          end
        end
        
        love.graphics.setColor(colors.white)
      end,
      update = function(self, dt)
        -- showing visible
        -- 0 0 0
        -- 1 0 0
        -- 0 1 1
        -- 1 1 1
        
        -- TODO : make this condition cleaner
        
        if gui_get_element(get_gui(), "inventory_panel").visible then
          if gui_get_element(get_gui(), "inventory_panel").showing_item then
            self.active = false
          else
            self.active = true
          end
        else
          self.active = false
        end
      end,
      mousepressed = function(self, x, y, button)
        if button == 1 then
          local tx, ty = 0, 0
          for i, v in pairs(get_player().inventory) do
            if math.point(
              { x = x,
                y = y},
              { x = tx*16,
                y = (ty+46-10)*16+4,
                w = love.graphics.newText(gui.font, v.quantity .. "x " .. data.items[v.id].name):getWidth(),
                h = love.graphics.newText(gui.font, v.quantity .. "x " .. data.items[v.id].name):getHeight()}
            ) then
              
              gui_add_element(get_gui(), create_item_listing(
                0, get_gui().panel_messages.y-16*10+4, 200, 100, v
              ), "inventory_show_item", 10, "inventory_panel")
              gui_get_element(get_gui(), "inventory_panel").showing_item = true
              
              gui_add_element(get_gui(), create_text_button(
                20*16, get_gui().panel_messages.y-16*10+4, 
                "[y] " .. lang_get_url_translation("gui.back"), 
                get_gui().font, colors.silver,
                function(sself, x, y, button)
                  inventory_remove_item_show()
                end, function() end,
                "y"
              ), "back_item", 10, "inventory_panel")
              
              if not v.is_material then
                gui_add_element(get_gui(), create_text_button(
                  30*16, get_gui().panel_messages.y-16*10+4, 
                  "[u] " .. lang_get_url_translation("gui.use"), 
                  get_gui().font, colors.silver,
                  function(sself, x, y, button)
                    player_use_item(get_player(), i, v)
                    inventory_remove_item_show()
                  end, function() end,
                  "u"
                ), "use_item", 10, "inventory_panel")
              end
          
              gui_add_element(get_gui(), create_text_button(
                40*16, get_gui().panel_messages.y-16*10+4, 
                "[t] " .. lang_get_url_translation("gui.throw_away"), 
                get_gui().font, colors.silver,
                function(sself, x, y, button)
                  table.remove(get_player().inventory, i)
                  inventory_remove_item_show()
                end, function() end,
                "t"
              ), "throw_item", 10, "inventory_panel")
              
            end
      
            ty = ty + 1
            --self.active = gui_get_element(get_gui(), "inventory_panel").visible
            if ty >= 10 then
              ty = 0
              tx = i*2
            end
          end
        end
      end
    }
  )
  
  return ge
end

function inventory_remove_item_show()
  gui_get_element(get_gui(), "inventory_panel").showing_item = false
  gui_remove_element(get_gui(), "inventory_show_item")
  gui_remove_element(get_gui(), "back_item")
  gui_remove_element(get_gui(), "use_item")
  gui_remove_element(get_gui(), "throw_item")
end