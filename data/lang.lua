

data.lang = {
	spanish = {
		items = {
			bronze_sword = "Espada de bronze",
			ancestral_sword = "Espada ancestral",
			olithen_battle_axe = "Hacha de batalla de Olithen",
			basic_iron_ring = "Anillo de hierro basico",
			crystabell_plated_helmet = "Casco chapado de Crystabell",
			scroll_lightning_bolt = "Hechizo de rayo",
			scroll_fire_explosion = "Hechizo de explosion de fuego",
			potion_healing = "Pocion de curacion",
			potion_regeneration = "Pocion de regeneracion",
			potion_mana = "Potion de mana",
			healing_herb = "Hierba de curacion",
			bottle = "Botella vacia"
		},

		biomes = {
			dungeon = "Mazmorra",
			plains = "Explanadas",
			desert = "Desierto",
			cursed_woods = "Bosque maldito",
			["nil"] = "No"
		},

		gui = {
			dungeon_level = "Nivel de mazmorra: ",
			empty_slot = "Espacio vacio",
			use = "Usar",
			back = "Atras",
			throw_away = "Tirar",
			exit_gui = "Salir de la interfaz",
			inventory = {
				full_inventory = "Tienes el inventario lleno!",
				pick_up = "Has cojido "
			},
			craft = "Fabricar"
		},

		stats = {
			power = "Poder",
			durability = "Durabilidad",
			healing = "Curacion",
			turns = "Turnos",
			cooldown = "Enfriamiento",
			health = "Vida",
			mana = "Mana",
			defense = "Defensa",
			mana_healing = "Curacion de mana"
		},

		rpc = {
			loading = "Cargando...",
			playing_as = "Jugando como ",
			in_biome = "En un "
		}
	},



	english = {
		items = {
			bronze_sword = "Bronze Sword",
			ancestral_sword = "Ancestral Sword",
			olithen_battle_axe = "Olithen Battle Axe",
			basic_iron_ring = "Basic Iron Ring",
			crystabell_plated_helmet = "Crystabell's Plated Helmet",
			scroll_lightning_bolt = "Lightning Bolt Scroll",
			scroll_fire_explosion = "Fire Explosion Scroll",
			potion_healing = "Healing Potion",
			potion_regeneration = "Regeneration Potion",
			potion_mana = "Mana Potion",
			healing_herb = "Healing Herb",
			bottle = "Empty Bottle"
		},

		biomes = {
			dungeon = "Dungeon",
			plains = "Plains",
			desert = "Desert",
			cursed_woods = "Cursed Woods",
			["nil"] = "No"
		},

		gui = {
			dungeon_level = "Dungeon level: ",
			empty_slot = "Empty slot",
			use = "Use",
			back = "Back",
			throw_away = "Throw away",
			exit_gui = "Exit GUI",
			inventory = {
				full_inventory = "Your inventory is full!",
				pick_up = "You picked up "
			},
			craft = "Craft"
		},

		stats = {
			power = "Power",
			durability = "Durability",
			healing = "Healing",
			turns = "Turns",
			cooldown = "Cooldown",
			health = "Health",
			mana = "Mana",
			defense = "Defense",
			mana_healing = "Mana healing"
		},

		rpc = {
			loading = "Loading...",
			playing_as = "Playing as ",
			in_biome = "In a "
		}
	},
	selected = "english",
	keys = {}
}

function lang_create_key(url)
	if data.lang.keys[url] then
		return data.lang.keys[url];
	else
		local k = {
			url = url,
			cached = ""
		}
		k.cached = _lang_get_from_url(url);
		setmetatable(k, {
			__tostring = function(self)
				return self.cached
			end
		})
		data.lang.keys[url] = k
		return k;
	end
end

function _lang_get_from_url(url)
	local actp = data.lang[data.lang.selected]
	for path_node in string.gmatch(url, "[%w_]+") do
		if type(actp) ~= "table" then
			print("NON-FATAL: Couldn't find translation key.");
			return url;
		else
			actp = actp[path_node]
		end
	end
	return actp;
end

function lang_get_translation(key)
	return key.cached;
end

function lang_get_url_translation(url)
	local a = lang_get_translation(lang_create_key(url));
	return a;
end

function lang_change(new_lang)

end