-- Mainly translation data

data.stats = {
  power = {
    name = "Power",
    color = colors.darkred
  },
  durability = {
    name = "Durability",
    color = colors.aqua
  },
  healing = {
    name = "Healing",
    color = colors.pink
  },
  turns = {
    name = "Turns",
    color = colors.antiquewhite,
    upgradeable = false
  },
  cooldown = {
    name = "Cooldown",
    color = colors.honeydew
  },
  health = {
    name = "Health",
    color = colors.lightgreen
  },
  defense = {
    name = "Defense",
    color = colors.royalblue
  },
  mana_healing = {
    name = "Mana Regeneration",
    color = colors.royalblue
  }
}

function stats_update_translation()
  for i, v in pairs(data.stats) do
    v.name = lang_create_key("stats."..i).cached or "stats."..i;
  end
end

stats_update_translation();