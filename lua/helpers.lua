-- =============================================================================
-- MILESTONES — Lua Helper Library
-- File: lua/helpers.lua
--
-- PURPOSE:
--   A collection of well-commented utility functions for use in WML events
--   via the [lua] tag.  Load this file from any scenario with:
--
--     [event]
--         name=prestart
--         [lua]
--             code=<<
--                 milestones = wesnoth.dofile("~add-ons/Milestones/lua/helpers.lua")
--             >>
--         [/lua]
--     [/event]
--
--   After loading, call functions as:
--     milestones.message("hero", "Hello, world!")
--
-- WML/Lua API reference:
--   https://wiki.wesnoth.org/LuaWML
-- =============================================================================

local M = {}  -- Module table; all public functions go here.

-- -----------------------------------------------------------------------------
-- VARIABLES
-- Helper functions for reading and writing WML campaign variables.
-- Campaign variables persist across scenarios in the save-game file.
-- -----------------------------------------------------------------------------

--- Set a WML variable to a value.
-- @param name  string  Variable name (no spaces; use underscores).
-- @param value any     Value to store (string, number, or boolean).
function M.set_var(name, value)
    wesnoth.set_variable(name, value)
end

--- Get a WML variable's current value.
-- Returns nil if the variable is not set.
-- @param name  string  Variable name.
-- @return any
function M.get_var(name)
    return wesnoth.get_variable(name)
end

--- Increment a numeric WML variable by a given amount (default 1).
-- @param name   string  Variable name.
-- @param amount number  Amount to add (default 1).
function M.increment_var(name, amount)
    amount = amount or 1
    local current = wesnoth.get_variable(name) or 0
    wesnoth.set_variable(name, current + amount)
end

--- Clear (delete) a WML variable.
-- @param name  string  Variable name.
function M.clear_var(name)
    wesnoth.set_variable(name, nil)
end

-- -----------------------------------------------------------------------------
-- UNITS
-- Helper functions for finding and manipulating units on the map.
-- -----------------------------------------------------------------------------

--- Find a unit on the map by its WML id attribute.
-- Returns the unit object, or nil if not found.
-- @param id  string  The unit's id as set in WML.
-- @return unit|nil
function M.find_unit(id)
    local units = wesnoth.get_units({ id = id })
    return units[1]  -- get_units returns a table; [1] is the first match.
end

--- Find all units belonging to a specific side.
-- @param side_num  number  The side number (1, 2, 3, …).
-- @return table   A table of unit objects.
function M.get_side_units(side_num)
    return wesnoth.get_units({ side = side_num })
end

--- Heal a unit by id to full health.
-- @param id  string  The unit's id.
function M.full_heal(id)
    local unit = M.find_unit(id)
    if unit then
        unit.hitpoints = unit.max_hitpoints
    end
end

--- Move a unit instantly to a new location.
-- This is a teleport, not a walk — no movement points are consumed.
-- @param id  string  The unit's id.
-- @param x   number  Target column (1-based).
-- @param y   number  Target row (1-based).
function M.teleport_unit(id, x, y)
    local unit = M.find_unit(id)
    if unit then
        wesnoth.put_unit(unit, x, y)
    end
end

--- Check whether a unit with the given id is alive and on the map.
-- @param id  string  The unit's id.
-- @return boolean
function M.unit_alive(id)
    return M.find_unit(id) ~= nil
end

-- -----------------------------------------------------------------------------
-- MESSAGING
-- Wrappers around the WML [message] tag for use from Lua.
-- -----------------------------------------------------------------------------

--- Display a dialogue message in the standard WML speech-bubble style.
-- @param speaker  string  Unit id, or "narrator" / "unit" / "second_unit".
-- @param text     string  The message text (already localised).
function M.message(speaker, text)
    wesnoth.fire("message", {
        speaker = speaker,
        message = text,
    })
end

--- Display a narrator message with a custom image.
-- @param image  string  Path to the portrait image.
-- @param text   string  The message text.
function M.narrator_message(image, text)
    wesnoth.fire("message", {
        speaker = "narrator",
        image   = image,
        message = text,
    })
end

-- -----------------------------------------------------------------------------
-- GOLD
-- Helper functions for adjusting side gold.
-- -----------------------------------------------------------------------------

--- Add gold to a side.
-- @param side_num  number  The side number.
-- @param amount    number  Amount of gold to add (can be negative to subtract).
function M.add_gold(side_num, amount)
    local side = wesnoth.sides[side_num]
    if side then
        side.gold = side.gold + amount
    end
end

--- Set a side's gold to an exact amount.
-- @param side_num  number  The side number.
-- @param amount    number  New gold total.
function M.set_gold(side_num, amount)
    local side = wesnoth.sides[side_num]
    if side then
        side.gold = amount
    end
end

-- -----------------------------------------------------------------------------
-- EVENTS
-- Utilities for firing WML events programmatically.
-- -----------------------------------------------------------------------------

--- Fire a named WML event.
-- Equivalent to [fire_event] name=event_name in WML.
-- @param event_name  string  The name of the event to fire.
function M.fire(event_name)
    wesnoth.fire_event(event_name)
end

-- -----------------------------------------------------------------------------
-- TERRAIN
-- Helper to change terrain at a given coordinate.
-- -----------------------------------------------------------------------------

--- Change the terrain at a hex.
-- @param x        number  Column (1-based).
-- @param y        number  Row (1-based).
-- @param terrain  string  Wesnoth terrain code, e.g. "Gg", "Uu", "Ke".
-- @param mode     string  "both" (default), "base", or "overlay".
function M.set_terrain(x, y, terrain, mode)
    mode = mode or "both"
    wesnoth.set_terrain(x, y, terrain, mode)
end

-- -----------------------------------------------------------------------------
-- MISC
-- Miscellaneous utilities.
-- -----------------------------------------------------------------------------

--- Return true with a given probability (0–100).
-- Useful for random branching events.
-- @param percent  number  Probability as a percentage (0–100).
-- @return boolean
function M.chance(percent)
    return math.random(100) <= percent
end

--- Clamp a number between min and max.
-- @param value  number
-- @param min    number
-- @param max    number
-- @return number
function M.clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

-- Return the module so callers can do:
--   milestones = wesnoth.dofile("~add-ons/Milestones/lua/helpers.lua")
return M
