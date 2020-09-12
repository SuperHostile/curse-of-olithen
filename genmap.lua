-- map node = {tile, explored}
-- TODO : CONCEPT OF AREAS FOR OPTIMIZED RENDERING OF EVERYTHING
map = {}

is_generating = false
gen_stage = "no"

-- Thanks to https://github.com/AtTheMatinee/dungeon-generation/blob/master/dungeonGenerationAlgorithms.py#L291
SCREEN_WIDTH = 80
SCREEN_HEIGHT = 60
TEXTBOX_HEIGHT = 10

--MAP_WIDTH  = (math.floor(love.graphics.getWidth() / 16)) - (cgui().panel_stats.w/16)
--MAP_HEIGHT  = (math.floor(love.graphics.getHeight() / 16)) - (cgui().panel_messages.h/16)
MAP_WIDTH = 100
MAP_HEIGHT = 100

MAX_ROOMS = 10
ROOM_MAX_SIZE = 10
ROOM_MIN_SIZE = 15

AREA_SIZE = 50

ENEMIES_PER_ROOM = 3
ITEMS_PER_ROOM = 100

player_start_x = 0
player_start_y = 0

-- TODO : enemies can generate in the player's tile
genmap = {
  rooms = {},
  map = {},
  areas = {},
  map_node = function(tile, explored)
    return {
      tile = tile or 1,
      explored = explored or false
    }
  end,
  addRect = function(self, room)
    --table.insert(self.rooms, room)
    for x = room.x1 + 1, room.x2 do
      for y = room.y1 + 1, room.y2 do
        self.map[x][y] = genmap.map_node(0)
      end
    end
  end,
  createHorTunnel = function(self, x1, x2, y)
    for x = math.min(x1, x2), math.max(x1, x2) do
      self.map[x][y] = genmap.map_node(0)
    end
  end,
  createVerTunnel = function(self, y1, y2, x)
    for y = math.min(y1, y2), math.max(y1, y2) do
      self.map[x][y] = genmap.map_node(0)
    end
  end,
  rect = function(x, y, w, h)
    return {
      x1 = x,
      y1 = y,
      x2 = x+w,
      y2 = y+h,
      center = function(self)
        centerX = (self.x1 + self.x2)/2
        centerY = (self.y1 + self.y2)/2
        return math.round(centerX), math.round(centerY)
      end,
      intersect = function(self, other)
        return (self.x1 <= other.x2 and self.x2 >= other.x1 and
        self.y1 <= other.y2 and self.y2 >= other.y1)
      end
    }
  end,

}

-- Creates an area
function create_area(x, y)
  local a = {
    x = x or 0,
    y = y or 0,
    data = {},
    biome = produce_biome(),
    place = "olithen"
  }
  
  --[[for i = x, x+AREA_SIZE do
    for j = y, y+AREA_SIZE do
      table.insert(a.data, {x=i,y=j})
    end
  end]]
  
  return a
end

-- Populates a room with stuff
function room_populate_special(r)
  local ex, ey = math.floor(math.random(r.x1, r.x2)), 
                 math.floor(math.random(r.y1, r.y2))
  if genmap.map[ex+1] ~= nil then
    if genmap.map[ex+1][ey+1] ~= nil and genmap.map[ex+1][ey+1].tile == 0 then
      table.insert(stations, cstation(
        "a",
        ex,
        ey
      ))
    end
  end
end

function room_populate(r, e_flag, i_flag, s_flag)
  e_flag = e_flag or true
  i_flag = i_flag or true
  s_flag = s_flag or true
  if s_flag then return room_populate_special(r) end 
  if e_flag then
    for i = 1, ENEMIES_PER_ROOM do
      local ex, ey = math.floor(math.random(r.x1, r.x2)), 
                     math.floor(math.random(r.y1, r.y2))
      if genmap.map[ex+1] ~= nil then
        if genmap.map[ex+1][ey+1] ~= nil and genmap.map[ex+1][ey+1].tile == 0 then
          table.insert(enemies, cenemy(
            ex,
            ey
          ))
        end
      end
    end
  end
  
  if i_flag then
    for i = 1, ITEMS_PER_ROOM do
      local ix, iy = math.floor(math.random(r.x1, r.x2)), 
                     math.floor(math.random(r.y1, r.y2))
      if genmap.map[ix+1] ~= nil then
      if genmap.map[ix+1][iy+1] ~= nil and genmap.map[ix+1][iy+1].tile == 0 then
        table.insert(items, citem(
          ix,
          iy,
          produce_item(1)
        ))
      end
      end
    end
  end
  
end

-- Fills up the entire map
function tick_fill_map(i)
  genmap.map[i] = {}
  for j = 1, MAP_HEIGHT do
    genmap.map[i][j] = genmap.map_node(1)
  end
end

-- Empties the entire map
function empty_map()
  for i = 1, MAP_WIDTH do
  genmap.map[i] = {}
  for j = 1, MAP_HEIGHT do
    genmap.map[i][j] = genmap.map_node(0)
  end
  end
end


-- Divides the map into areas
function create_areas(i)
  genmap.areas[i] = {}
  for j = 1, math.floor(MAP_HEIGHT/AREA_SIZE) do
    genmap.areas[i][j] = create_area((i-1)*AREA_SIZE, (j-1)*AREA_SIZE)
  end
end

-- Generates a room
function generate_room(i)
  local failed = false
  
  -- Creates a rectangular room
  local w = math.floor(math.random(ROOM_MIN_SIZE, ROOM_MAX_SIZE))
  local h = math.floor(math.random(ROOM_MIN_SIZE, ROOM_MAX_SIZE))
  
  local x = math.floor(math.random(0, MAP_WIDTH - w -1))
  local y = math.floor(math.random(0, MAP_HEIGHT - h -1))
  
  -- Checks if the room intersects with any other room
  -- If yes, then do nothing
  -- If no, create tunnels and add it to the map
  local new_room = genmap.rect(x, y, w, h)
  for i, other in pairs(genmap.rooms) do
    if other ~= nil then
      if new_room:intersect(other) then
        failed = true
      end
    end
  end
  
  if not failed then
    genmap:addRect(new_room)
    new_x, new_y = new_room:center()
    
    if #genmap.rooms ~= 0 then
      local prev_x, prev_y = genmap.rooms[#genmap.rooms]:center()
      
      room_populate(new_room)
      
      -- Dont know how it works, but it DOES.
      if math.round(math.random(0, 1)) == 1 then
        genmap:createHorTunnel(prev_x, new_x, prev_y)
        genmap:createVerTunnel(prev_y, new_y, new_x)
      else
        genmap:createVerTunnel(prev_y, new_y, prev_x)
        genmap:createHorTunnel(prev_x, new_x, new_y)
      end
      
    else
      
      if player ~= nil then
        player.x = new_x
        player.y = new_y
      end
      
      player_start_x = new_x
      player_start_y = new_y
    end
    
    table.insert(genmap.rooms, new_room)
  end
end


-- Constructs the final map
function construct_map(m, a)
  local tmap = m
  
  tmap.areas = a or {}
  tmap.get_area_in_pos = function(self, x, y)
    --print(math.floor(x/AREA_SIZE), math.floor(y/AREA_SIZE))
    return self.areas[math.floor(x/AREA_SIZE)+1][math.floor(y/AREA_SIZE)+1]
  end
  
  return tmap
end

-- Generates the entire map
function generate_map()

  is_generating = true
  gen_stage = "fill_map"
  game_state = "gen_map"
  
  map = {}
  enemies = {}
  items = {}
  stations = {}
  genmap.map = {}
  genmap.rooms = {}
  genmap.areas = {}
  collectgarbage()
  
  --empty_map()
  
  gen_map_ticks = {
    fill_map = 10,
    create_areas = 1,
    generate_room = 5
  }
  
  ticker:register_tick(
    tick_fill_map,
    MAP_WIDTH+1,
    "fill_map",
    function()
      gen_stage = "create_areas"
      ticker:register_tick(
        create_areas,
        math.floor(MAP_WIDTH/AREA_SIZE)+1,
        "create_areas",
        function()
          gen_stage = "generate_room"
          ticker:register_tick(
            generate_room,
            MAX_ROOMS,
            "generate_room",
            function()
              --player_start_x, player_start_y = 0, 0
              map = construct_map(genmap.map, genmap.areas)
              player.x = player_start_x
              player.y = player_start_y
              table.insert(stations, cstation(
                "a",
                player_start_x+1,
                player_start_y
              ))
              change_game_state("playing")
              is_generating = false
            end
          )
        end
      )
    end
  )

-- Generate the entire map
  --map.areas = genmap.areas

  stairs_x, stairs_y = 0,0

  --[[stairs_x, stairs_y = new_x, new_y
  map[new_x][new_y] = genmap.map_node(2)

  is_generating = false]]

end

--generate_map()

-- TODO : OPTIMIZATIONS
function map_draw(m)
  --love.graphics.setFont(char().font)
  for x, v in ipairs(m) do
    for y, b in ipairs(v) do
      if b.explored and player_can_see(x, y) then
        --print(x, y, m:get_area_in_pos( x, y ))
        --print(data.biomes[m:get_area_in_pos( (x-1), (y-1) ).biome].name)
        love.graphics.setColor(data.biomes[m:get_area_in_pos( (x-1), (y-1) ).biome].color)
        if b.tile == 1 then
         love.graphics.print("#", (x-1)*16, (y-1)*16)
         --love.graphics.rectangle("fill", (x-1)*16, (y-1)*16, 16, 16)
        elseif b.tile == 0 then
          love.graphics.print(".", (x-1)*16, (y-1)*16)
        else 
          love.graphics.print("%", (x-1)*16, (y-1)*16)
        end
      end
    end
  end
  
  love.graphics.setColor(colors.green)
  
  for i, v in ipairs(m.areas) do
    for j, area in ipairs(v) do
      --love.graphics.rectangle("line", area.x*16, area.y*16, AREA_SIZE*16, AREA_SIZE*16)
    end
  end
  
  love.graphics.setColor(colors.white)
  
end

function map_draw_pause(m)
  for x, v in ipairs(m) do
    for y, b in ipairs(v) do
      if b.explored and player_can_see_pause(x, y) then
        --print(x, y, m:get_area_in_pos( x, y ))
        --print(data.biomes[m:get_area_in_pos( (x-1), (y-1) ).biome].name)
        love.graphics.setColor(data.biomes[m:get_area_in_pos( (x-1), (y-1) ).biome].color)
        if b.tile == 1 then
         love.graphics.print("#", (x-1)*16, (y-1)*16)
         --love.graphics.rectangle("fill", (x-1)*16, (y-1)*16, 16, 16)
        elseif b.tile == 0 then
          love.graphics.print(".", (x-1)*16, (y-1)*16)
        else 
          love.graphics.print("%", (x-1)*16, (y-1)*16)
        end
      end
    end
  end
  
  love.graphics.setColor(colors.white)
end

--24