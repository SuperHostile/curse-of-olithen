game_states = {}
game_state = ""

function new_game_state(nm, lt)
  lt.game_state_data = {}
	game_states[nm] = lt
end

function game_state_event(ev, ...)
	if game_states[game_state] then
		if game_states[game_state][ev] then
			game_states[game_state][ev](game_states[game_state].game_state_data, ...)
		end
	end
end

function change_game_state(name)
  game_state = name
  game_state_event("load")
end


require "game_states/gen_map"
require "game_states/playing"
require "game_states/pause_menu"
require "game_states/main_menu"

require "game_states/stations/alchemism"

change_game_state("main_menu")