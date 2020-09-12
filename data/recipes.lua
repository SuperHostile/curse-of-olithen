function new_recipe()
end

data.recipes = {
	alchemy = {
		{
			output = {
				id = "potion_healing",
				quantity = 1
			},
			input = {
				{"healing_herb", 3},
				{"bottle", 1}
			}
		},
		{
			output = {
				id = "potion_regeneration",
				quantity = 1
			},
			input = {
				{"healing_herb", 5},
				{"bottle", 1}
			}
		}
	}
}