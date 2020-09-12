require "gui/elements/gui_element"
require "gui/elements/label/text_label"
require "gui/elements/text_button"
require "gui/elements/label/colored_text_label"
require "gui/elements/bar"
require "gui/elements/panel"

require "gui/elements/listing/message_feed"
require "gui/elements/listing/item_listing"
require "gui/elements/listing/inventory_listing"
require "gui/elements/listing/equipped_item_listing"
require "gui/elements/listing/recipe_listing"

function cgui()
  --[[if gui ~= nil then
    for i, element in pairs(gui.elements) do
      print("removed gui element: " .. element.element_name)
      gui_remove_element(gui, element.element_name)
    end
  end]]
  return {
    panel_stats = {
      x = love.graphics.getWidth()-(16*18),
      y = 0,
      w = 16*18,
      h = love.graphics.getHeight()
    },
    messages = {},
    panel_messages = {
      x = 0,
      y = love.graphics.getHeight()-(16*10),
      w = love.graphics.getWidth(),
      h = 16*10,
      mode = "inventory", 
      item = {}, -- Item to show in the show_item state
    },
    item_show = {}, -- Item currently showing
    font = love.graphics.newFont("font.ttf", 16),
    default_font = love.graphics.getFont(),
    elements = {},
    z_groups = {}
  }
end

MAX_MESSAGES = 10

function gui_add_element(gui, element, name, z, parent)
  if name ~= nil then
    element.parent = parent or 0
    gui.elements[name] = element
    local ez = z or 1
    if gui.z_groups[ez] == nil then gui.z_groups[ez] = {}; end
    table.insert(gui.z_groups[ez], name)
    element.z = z or 1
    element.z_index = #gui.z_groups[ez] or 1
    element.element_name = name
    if element.load ~= nil then print("loaded element: " .. element.element_name); element:load() end
  end
end

function gui_remove_element(gui, name)
  if gui.elements[name] ~= nil then
    local e = table.copy(gui.elements[name])
    if e.on_removed ~= nil then
      print("removed element: " .. e.element_name)
      e:on_removed()
    end
    gui.z_groups[e.z][e.z_index] = nil
    gui.elements[name] = nil
    return e
  end
end

function gui_get_element(gui, name)
  return gui.elements[name]
end

function gui_predraw(gui)
  
end

function gui_draw(gui)
  love.graphics.setFont(gui.font)
  for i, group in pairs(gui.z_groups) do
    for j, element_name in pairs(group) do
      local v = gui.elements[element_name]
      if v.draw and (v.visible and v.active) then v:draw() end
    end
  end
  love.graphics.setFont(gui.default_font)
end

function gui_keypressed(gui, key)
  for i, v in pairs(gui.elements) do
    if v.keypressed and v.active then v:keypressed(key) end
  end
end

function gui_mousepressed(gui, x, y, button)
  for i, v in pairs(gui.elements) do
    if v.mousepressed and v.active then v:mousepressed(x, y, button) end
  end
end

function gui_update(gui, dt)
  for i, v in pairs(gui.elements) do
    if v.parent ~= 0 then
      if not gui_get_element(gui, v.parent).visible then v.visible = false end
      if not gui_get_element(gui, v.parent).active then v.active = false end
      
      if not v.visible then
        if gui_get_element(gui, v.parent).visible then v.visible = true end
      end
      
      if not v.active then
        if gui_get_element(gui, v.parent).active then v.active = true end
      end
      
    end
  end
  --gui.bar_health:update(dt, player.health, player.max_health)
  gui_get_element(gui, "bar_health"):update(dt, player.health, player.max_health)
  gui_get_element(gui, "bar_mana"):update(dt, player.mana, player.max_mana)
  gui_get_element(gui, "label_dungeon_level"):update(dt, lang_get_url_translation("gui.dungeon_level") .. dungeon_level)
  gui_get_element(gui, "label_fps"):update(dt, "FPS: " .. love.timer.getFPS())
  gui_get_element(gui, "inventory_listing"):update(dt)
  gui_get_element(gui, "weapon_listing_equipped").item = get_player().equipped_weapon
end

function gui_playing()
  gui = cgui()
  gui_add_element(gui, create_text_label(
  gui.panel_stats.x+4, 16*3,
    "FPS: 0", gui.font
  ), "label_fps", -10)
  gui_add_element(gui, create_colored_text_label(
      4, 4, 
      "Dungeon Level: 0",
      gui.font, colors.darkred), "label_dungeon_level")

  gui_add_element(gui, create_panel(
        love.graphics.getWidth()-(16*18),
        0,
        16*18,
        love.graphics.getHeight()
  ), "stats_panel")

  gui_add_element(gui, create_panel(
        0,
        love.graphics.getHeight()-(16*10),
        love.graphics.getWidth(),
        16*10
  ), "message_panel")


  gui_add_element(gui, create_bar(
      gui.panel_stats.x+4, gui.panel_stats.y+4, 
      10, 100, 
      16*7, 
      colors.darkgreen, change_alpha(colors.darkgreen, 0.5), 
      lang_get_url_translation("stats.health")
    ), 
    "bar_health")

  gui_add_element(gui, create_bar(
      gui.panel_stats.x+4, gui.panel_stats.y+24, 
      10, 100, 
      16*7, 
      colors.royalblue, change_alpha(colors.royalblue, 0.5), 
      lang_get_url_translation("stats.mana")
    ), 
    "bar_mana")

  gui_add_element(gui, create_message_feed(
      0, gui.panel_messages.y
    ),
    "message_feed"
  )

  local panel_inventory = create_panel(0, gui.panel_messages.y-16*10, gui.panel_messages.w,  gui.panel_messages.h)

  panel_inventory.keypressed = function(self, key)
    if key == "s" then self.visible = not self.visible end
  end

  gui_add_element(gui, panel_inventory,
    "inventory_panel"
  )

  gui_add_element(gui, create_inventory_listing(
      0, gui.panel_messages.y-16*10, gui.panel_messages.w, gui.panel_messages.h
    ),
    "inventory_listing",
    10
  )

  gui_add_element(gui, create_item_listing(
    love.graphics.getWidth()-gui.panel_stats.w+4,
    gui.panel_messages.y+4,
    100,
    gui.panel_messages.h,
    nil
  ), "weapon_listing_equipped")

  gui_add_element(gui, create_equipped_item_listing(
    gui.panel_stats.x, 10*16, 100, 100
  ), "item_listing_equipped")

end

function print_message(text, color)
  gui_get_element(gui, "message_feed"):print_message(text, color)
end

function gui_alchemism()
  gui_playing()
  gui_remove_element(gui, "inventory_listing")
  gui_remove_element(gui, "message_feed")
  --gui_get_element(gui, "message_feed").visible = false
  gui_add_element(gui, create_inventory_listing(
      0, gui.panel_messages.y, gui.panel_messages.w, gui.panel_messages.h
    ),
    "inventory_listing",
    10
  )
  gui_add_element(gui, create_text_button(
    0, 0, "[esc] " .. lang_get_url_translation("gui.exit_gui"), gui.font, colors.white, 
    function() change_game_state("playing") end, function() end, "escape"
  ), "exit_gui_button", 10)

  gui_add_element(gui, create_panel(
    3*16, 3*16,
    love.graphics.getWidth()-gui.panel_stats.w-96,
    love.graphics.getHeight()-gui.panel_messages.h-256
  ), "panel_alchemism")

  gui_add_element(gui, create_recipe_listing(
    "alchemy", 80, 80,
    love.graphics.getWidth()-gui.panel_stats.w-160,
    love.graphics.getHeight()-(gui.panel_messages.h*2)-160
  ), "recipe_listing");

  gui_add_element(gui, create_text_button(
    3*16, love.graphics.getHeight()-gui.panel_messages.h-16*14, 
    "[c] ".. lang_get_url_translation("gui.craft"), gui.font, colors.white, function() 
      gui_get_element(gui, "recipe_listing"):craft();
    end, function() end, "c"
  ), "craft_button", 10)
end

messages_in_feed = {{msg="fsa",color=colors.white}}