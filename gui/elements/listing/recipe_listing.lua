function create_recipe_listing(recipe_id, x, y, w, h, parent)
	local rel = create_gui_element(x, y, w, h,
		{
			recipe_id = recipe_id,
			selected_recipe = "",
			draw = function(self)
				love.graphics.setColor(colors.lpanel);
				-- TODO : Make this rectangles more pixelated
				love.graphics.rectangle("line", self.x, self.y, self.w, self.h, 3);
				love.graphics.rectangle("line", self.x, self.y, self.w/2, self.h, 3);

				--  Draws the list of recipes
				for i, v in ipairs(data.recipes[self.recipe_id]) do

					-- Draws a rectangle under the recipe which is under the mouse.
					if math.point({x = love.mouse.getX(), y = love.mouse.getY()}, {x=self.x,y=self.y+((i-1)*16),w=self.w/2,h=16}) then
						love.graphics.setColor(0.3, 0.3, 0.3, 0.3);
						love.graphics.rectangle("fill", self.x, self.y+((i-1)*16), self.w/2, 16);
					end
					love.graphics.setColor(1, 1, 1, 1);
					love.graphics.print(v.output.quantity .. "x " .. data.items[v.output.id].name, self.x, self.y+((i-1)*16));
				end

				-- Draws the recipe's requirements
				if self.selected_recipe ~= "" then
					for i, v in pairs(self.selected_recipe.input) do
						love.graphics.print(v[2] .. "x " .. data.items[v[1]].name, self.x+self.w/2, self.y+((i-1)*16));
					end
				end
			end,
			mousepressed = function(self, mx, my, button)

				-- Checks if a recipe has been pressed.
				for i, v in ipairs(data.recipes[self.recipe_id]) do
					if math.point({x = mx, y = my}, {x=self.x,y=self.y+((i-1)*16),w=self.w/2,h=16}) then
						print(v.output.quantity .. "x " .. data.items[v.output.id].name);
						self.selected_recipe = v;
						break;
					end
				end
			end,
			craft = function(self)
				--print("test craft");
				
			end
		},
	parent);
	return rel
end