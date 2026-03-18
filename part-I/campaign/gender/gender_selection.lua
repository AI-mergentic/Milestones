-- #textdomain wesnoth-Milestones

-- Allows the player to choose whether the gender
local wml_actions = wesnoth.wml_actions
local _ = wesnoth.textdomain "wesnoth-Milestones"

function wml_actions.select_gender()
	local gender_selection_dialog = wml.load "~add-ons/Milestones/part-I/campaign/gender/gender_selection.cfg"
	if not gender_selection_dialog then
		wesnoth.interface.add_chat_message("", "[Milestones Error]: Failed to load gender selection dialog configuration.")
		return
	end
	local dialog_wml = wml.get_child(gender_selection_dialog, 'resolution')
	if not dialog_wml then
		wesnoth.interface.add_chat_message("", "[Milestones Error]: Gender selection dialog resolution missing.")
		return
	end

	local gender = gui.show_dialog(dialog_wml) -- single‑player, no sync needed
	if not gender then
		wesnoth.interface.add_chat_message("", "[Milestones Info]: No gender selected. Default will be used.")
	end
	local store = wml.variables.Protagonistes_store
	-- WML arrays are 1-indexed; [0] is never used.
	local unit_data = store and store[1]

	-- Robust check: if unit is still nil, try to find it on the map (maybe it wasn't killed)
	if not unit_data then
		unit_data = wesnoth.units.find_on_map({ id = "Protagonistes" })[1]
		if not unit_data then
			wesnoth.interface.add_chat_message("", "[Milestones Warning]: Protagonist unit not found on map. Attempting fallback.")
		end
	end

	-- If STILL nil, we can't proceed safely
	if not unit_data then
		wesnoth.interface.add_chat_message("", "[Milestones Error]: Protagonist unit not found for gender selection. Scenario cannot proceed.")
		wesnoth.interface.add_chat_message("", "[Milestones Suggestion]: Please check scenario setup or unit spawning macros.")
		return
	end

	local side_num = tonumber(unit_data.side) or 1
	local side = wesnoth.sides[side_num]
	local loc = side and side.starting_location or {}
	local x = tonumber(unit_data.x) or loc.x or loc[1]
	local y = tonumber(unit_data.y) or loc.y or loc[2]
    
	if not x then
		local keep = wesnoth.map.find({ terrain = "*^K*", { "filter_side", { side = side_num } } })[1]
		x, y = (keep and (keep.x or keep[1])) or 1, (keep and (keep.y or keep[2])) or 1
		if not keep then
			wesnoth.interface.add_chat_message("", "[Milestones Warning]: No keep found for side. Defaulting to (1,1).")
		end
	end

	local gender_configs = {
		[1] = { type = "LIUN_Maiden_Cornet", extrarecruit = "LIUN_Maiden_Private", symbol = "🌸" },
		[2] = { type = "LIUN_Marine_Cornet", extrarecruit = "LIUN_Marine_Private", symbol = "🧿" }
	}

	local cfg = gender_configs[gender]
	if not cfg then
		wesnoth.interface.add_chat_message("", "[Milestones Error]: Invalid gender selection. No configuration found.")
		return
	end

	-- Spawn/Update Noa
	wesnoth.units.to_map({
		type = cfg.type,
		side = side_num,
		id = unit_data.id,
		name = _"Noa",
		unrenamable = true,
		canrecruit = true,
		facing = unit_data.facing or "s",
		x = x,
		y = y
	})
	-- keep the store variable in sync for other code
	-- wml.variables.Protagonistes_store = { unit_data } -- Disabled: causes WML/Lua type error

	-- Update Side attributes
	wesnoth.wml_actions.modify_side {
		side = side_num,
		extrarecruit = cfg.extrarecruit
	}
	
	wesnoth.add_known_unit(cfg.type)

	-- Feedback Message
	wesnoth.wml_actions.message {
		speaker = "narrator",
		caption = _"Excellent choice!",
		image = "wesnoth-icon.png",
		message = string.format(_"Okay, so in this campaign you will play as Noa %s", cfg.symbol)
	}
end 