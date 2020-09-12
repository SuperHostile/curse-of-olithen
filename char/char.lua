function char(c, x, y, col)
  return {
    t = "Generic",
    c = c or ".",
    x = x or 1,
    y = y or 1,
    col = col or {1, 1, 1, 1},
    font = love.graphics.newFont("font.ttf", 16),
    default_font = love.graphics.getFont(),
    attribute_table = {},
    move = function(self, dx, dy)
      if map[(self.x+dx)+1] == nil then return false end
      
      if (map[(self.x+dx)+1][(self.y+dy)+1].tile == 0 or map[(self.x+dx)+1][(self.y+dy)+1].tile == 2)
         and map[(self.x+dx)+1][(self.y+dy)+1].tile ~= nil 
         and not entity_check((self.x+dx), (self.y+dy)) then
        self.x = self.x + dx
        self.y = self.y + dy
        
        
        return true
      else
        local col_table = {type=""}
        local a, b = entity_check((self.x+dx), (self.y+dy))
        if a then 
          col_table.type = b.t
          trash, col_table.other = entity_check((self.x+dx), (self.y+dy))
        end
        return false, col_table
      end
    end,
    draw = function(self)
      --love.graphics.setFont(self.font)
      local r,g,b,a = love.graphics.getColor()
      love.graphics.setColor(self.col)
      love.graphics.print(self.c, self.x*16, self.y*16)
      love.graphics.setColor(r,g,b,a)
      --love.graphics.setFont(self.default_font)
    end
  }
end

-- Returns if the provided char is around the given tile.
function char_around(c, x, y)
  return (
    (c.x == x+1 and c.y == y+1) or
    (c.x == x+1 and c.y == y-1) or
    (c.x == x+1 and c.y == y) or
    (c.x == x-1 and c.y == y+1) or
    (c.x == x-1 and c.y == y-1) or
    (c.x == x-1 and c.y == y) or
    (c.x == x and c.y == y+1) or
    (c.x == x and c.y == y-1)
  )
end