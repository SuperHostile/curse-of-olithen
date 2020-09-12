math.randomseed(os.time())

-- DISCORD RICH PRESENCE IS NOT FINISHED
USE_PRESENCE = false

require "libs/global"
require "gui/color"
require "cmath"

-- Load data
data = {}
require "data/lang"
require "data/items"
require "data/stats"
require "data/biomes"
require "data/equipped"
require "data/recipes"

require "libs/rpcWrapper"

require "gui/game_gui"

ticker = require "ticker"
gui = cgui()

function get_player(index)
  return player
end

function get_gui(index)
  return gui
end

--gui_playing()

require "char/char"
require "char/player"
require "char/item"
require "char/enemy"
require "char/station"

require "genmap"




require "game_states/game_states"

--change_game_state("main_menu")

CAMERA_SCALE = 2

in_menu = false

function global_enemy_turn()
  for i, enemy in pairs(enemies) do
    enemy_turn(enemy, i)
  end
end

function entity_check(x, y)
  for i, e in pairs(enemies) do
    if x == e.x and y == e.y then
      return true, e
    end
  end
  
  for i, e in pairs(items) do
    if x == e.x and y == e.y then
      return true, e
    end
  end
  
  for i, e in pairs(stations) do
    if x == e.x and y == e.y then
      return true, e
    end
  end
  
  if player.x == x and player.y == y then
    return true,player
  end
  
  return false
end

function system_start()
  
end

function new_game()
  
  --gui.messages = {}
  
  change_game_state("playing")
  
  dungeon_level = 1
  
  --gui_playing()
  
  enemies = {}
  items = {}
  stations = {}
  
  generate_map()
  player = cplayer(player_start_x, player_start_y)
  gui_get_element(gui, "weapon_listing_equipped").item = player.equipped_weapon
  
end

function next_level()
  change_game_state("gen_map")
  dungeon_level = dungeon_level + 100
  generate_map()
end

function love.update(dt)
  if USE_PRESENCE then
    if nextPresenceUpdate < love.timer.getTime() then
      if map.get_area_in_pos ~= nil then
        --print(nextPresenceUpdate)
        update_presence("rpc.where.underground", data.biomes[map:get_area_in_pos( (player.x), (player.y) ).biome].name)
      else
        presence = {
          state = lang_get_url_translation("rpc.loading"),
          startTimestamp = now,
          largeImageKey = "pls"
        }
      end
      discordRPC.updatePresence(presence)
      nextPresenceUpdate = love.timer.getTime() + 3
    end
    discordRPC.runCallbacks()
  end
  game_state_event("update", dt)
end

function love.draw()
  game_state_event("draw")
end

function love.keypressed(key)
  game_state_event("keypressed", key)
  if key == "f2" then
    love.graphics.captureScreenshot("screenshot" .. os.time() .. ".png")
  end
end

function love.mousepressed(x, y, button)
  game_state_event("mousepressed", x, y, button)
end

function love.wheelmoved(dx, dy)
  game_state_event("wheelmoved", dx, dy);
end

function love.quit()
  discordRPC.shutdown()
end

function love.error(e)
  print(e);
  discordRPC.shutdown();
end