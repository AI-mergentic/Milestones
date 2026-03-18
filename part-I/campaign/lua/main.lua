-- resolve add-on path for compatibility with v1.19.x
local dramatispersonae_path = "~add-ons/Milestones/part-I/campaign/lua/dramatispersonae.lua"
local dramatispersonae = wesnoth.dofile(dramatispersonae_path)

if not dramatispersonae then
    wesnoth.interface.add_chat_message("", "[Milestones Error]: Could not load dramatispersonae.lua")
    return
end

-- Move global functions to top for strict mode safety
function _G.milestones_init_msg()
    wesnoth.wml_actions.message {
        speaker = "narrator",
        message = "Milestones Template Engine initialized. Roles exported to WML variables.    TIP: You can edit 'part-I/campaign/lua/dramatispersonae.lua' to change character types and recruits globally across all scenarios.",
        image = "portraits/humans/mage-silver.webp"
    }
end

-- Helper to apply role attributes to a unit
function _G.milestones_unit(role_key, side_num, x, y)
    side_num = tonumber(side_num) or error("milestones_unit: bad side " .. tostring(side_num))
    local r = dramatispersonae[role_key]
    if not r then return end

    -- Resolve target coordinates first (needed for both new and recalled units)
    -- x=0, y=0 (or unset) means: use default placement logic
    local cx, cy = tonumber(x), tonumber(y)
    if cx and cy and cx ~= 0 and cy ~= 0 then
        x, y = cx, cy
    else
        local side = wesnoth.sides[side_num]
        local loc = side and side.starting_location or {}
        x, y = loc.x or loc[1], loc.y or loc[2]
        if not x then
            local keep = wesnoth.map.find({ terrain = "*^K*", { "filter_side", { side = side_num } } })[1]
            if keep then x, y = keep.x or keep[1], keep.y or keep[2] end
        end
    end

    local on_map = wesnoth.units.find_on_map({ id = r.id })[1]
    local existing = on_map or wesnoth.units.find_on_recall({ id = r.id })[1]

    if existing then
        if not on_map then
            -- unit is in recall: move it onto the map at the resolved location
            if x and y and tonumber(x) and tonumber(y) then
                wesnoth.units.to_map(existing, tonumber(x), tonumber(y))
            else
                wesnoth.interface.add_chat_message("", "[Milestones Error]: Could not place unit '" .. tostring(r.id) .. "' due to invalid coordinates.")
            end
        end
        return
    end

    wesnoth.wml_actions.unit {
        side = side_num, id = r.id, name = r.name, type = r.type,
        canrecruit = r.canrecruit and "yes" or "no",
        unrenamable = r.unrenamable and "yes" or "no",
        x = x, y = y
    }
end

-- Ensure side leaders and attributes are present (proactive fix for missing leaders/AI)
function _G.milestones_ensure_leaders()
    -- Safely export dramatispersonae to WML variables at runtime ($milestones.dramatispersonae.protagonistes.type)
    -- We must convert the Lua table to a WML-compatible structure (table of tables)
    local function convert_value(val)
        if type(val) == "boolean" then
            return val and "yes" or "no"
        elseif type(val) == "table" then
            local tbl = {}
            for kk, vv in pairs(val) do
                tbl[kk] = convert_value(vv)
            end
            return tbl
        else
            return tostring(val)
        end
    end

    local wml_dramatispersonae = {}
    for k, v in pairs(dramatispersonae) do
        local content = {}
        for attr, val in pairs(v) do
            content[attr] = convert_value(val)
        end
        wml_dramatispersonae[#wml_dramatispersonae + 1] = { k, content }
    end
    wml.variables["milestones.dramatispersonae"] = wml_dramatispersonae

    local side_to_role = { [1] = "protagonistes", [2] = "antagonistes", [3] = "chorus", [4] = "deuteragonistes", [5] = "deuterantagonistes", [6] = "tritagonistes", [7] = "tritantagonistes", [8] = "tetragonistes", [9] = "tetrantagonistes" }
    
    for side_num, role_key in pairs(side_to_role) do
        local side = wesnoth.sides[side_num]
        local r = dramatispersonae[role_key]
        if side and r and (side.controller == "human" or side.controller == "ai") then
            if #wesnoth.units.find_on_map({ side = side.side, canrecruit = true }) == 0 then
                _G.milestones_unit(role_key, side.side)
            end

            if (side.recruit or "") == "" then
                wesnoth.wml_actions.modify_side { side = side.side, recruit = r.recruit }
            end
            
            if (side.side_name or "") == "" or side.side_name == "Side " .. side.side then
                wesnoth.wml_actions.modify_side { side = side.side, side_name = r.name }
            end
        end
    end
end
