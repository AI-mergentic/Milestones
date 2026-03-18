-- dramatispersonae.lua
-- centralised role definitions used by the Milestones template.
-- instead of repeating id/saveid/role fields, we build them from the key
-- this also makes it easy to export role attributes to WML variables for use in scenarios.

local function mkrole(key, params)
    -- uppercase initial letter for id, call it twice for saveid/role
    local id = params.id or (key:gsub("^%l", string.upper))
    return {
        id = id,
            saveid = params.saveid or id,
            role = params.role or id,
        name = params.name,
            unrenamable = true,
        type = params.type,
        profile = params.profile,
        canrecruit = params.canrecruit,
        extrarecruit = params.extrarecruit or "",
        placement = params.placement or "map,leader",
    }
end

-- if you specify 'canrecruit = true' than make sure the specific dramatispersona is
-- give its own side in your XX_ScenarioStage.cfg, see 00_Prologue.cfg
-- if default is 'canrecruit = false' than the specific dramatispersona is a sidekick
-- of the one another side, e.g. deuteragonistes is on side 1 of protagonistes,
-- deuterantagonistes is on side 2 of antagonistes , etc.pp.
-- In your XX_ScenarioStage.cfg you must give proper _X _Y coordinates on the map
-- meaning replacing the 0 0 in SPAWN_DRAMATISPERSONA _SIDE _ROLE _X _Y 
-- e.g. {SPAWN_DRAMATISPERSONA 3 chorus 0 0}
-- or you must provide a keep tile on your map for the function in main.lua
-- function _G.milestones_ensure_leaders() to place the unit on if no units of that side are present, e.g. {KEEP 3 0 0} for chorus on side 3.
local dramatispersonae = {
    protagonistes = mkrole("protagonistes", {
        id = "Protagonistes",
        name = "Protagonist",
        type = "LIUN_Maiden_Captain",
        profile = "portraits/Protagonistes.webp",
        canrecruit = true,
        extrarecruit = "LIUN_Sergeant, LIUN_Jaeger",
    }),
    antagonistes = mkrole("antagonistes", {
        name = "Antagonist",
        type = "Orcish Grunt",
        profile = "portraits/Antagonistes.webp",
        canrecruit = true,
        extrarecruit = "LIUN_Sergeant",
    }),
    chorus = mkrole("chorus", {
        name = "Chorus",
        type = "Mage",
        profile = "portraits/Chorus.webp",
        canrecruit = true,
        extrarecruit = "LIUN_Sergeant",
    }),
    deuteragonistes = mkrole("deuteragonistes", {
        name = "Deuteragonist",
        type = "White Mage",
        profile = "portraits/Deuteragonistes.webp",
        canrecruit = false,
    }),
    deuterantagonistes = mkrole("deuterantagonistes", {
        name = "Deuterantagonist",
        type = "Orcish Grunt",
        profile = "portraits/Deuterantagonistes.webp",
        canrecruit = false,
    }),
    tritagonistes = mkrole("tritagonistes", {
        name = "Tritagonist",
        type = "Mage",
        profile = "portraits/Tritagonistes.webp",
        canrecruit = false,
    }),
    tritantagonistes = mkrole("tritantagonistes", {
        name = "Tritantagonist",
        type = "Orcish Grunt",
        profile = "portraits/Tritantagonistes.webp",
        canrecruit = false,
    }),
    tetragonistes = mkrole("tetragonistes", {
        name = "Tetragonist",
        type = "Mage",
        profile = "portraits/Tetragonistes.webp",
        canrecruit = false,
    }),
    tetrantagonistes = mkrole("tetrantagonistes", {
        name = "Tetrantagonist",
        type = "Mage",
        profile = "portraits/Tetrantagonistes.webp",
        canrecruit = false,
    }),
}

return dramatispersonae