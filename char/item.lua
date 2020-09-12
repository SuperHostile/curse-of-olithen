-- This represents an item in the world, not in inventory
function citem(x, y, item_table)
  local item = char("!", x, y)
  item.t = "Item"
  item.item = item_table
  item.index = #items+1
  item.attribute_table = { -- Used for drawing
    item.item.name
  }
  return item
end

function item_update(i)
end

function item_draw(i)
  --i:draw()
  local r,g,b,a = love.graphics.getColor()
  love.graphics.setColor(i.col)
  love.graphics.print(i.c, (i.x*16), (i.y*16))
  love.graphics.setColor(r,g,b,a)
end

function item_delete(index)
  items[index] = nil
end