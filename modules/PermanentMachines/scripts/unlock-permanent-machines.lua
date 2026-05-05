local CONSTANTS = require("common.constants")

local lib_strings = require("lib.strings")

local replace_map = {}
for name, _ in pairs(prototypes.entity) do
    if lib_strings.starts_with(name, CONSTANTS.mod_name) and lib_strings.ends_with(name, "-permanent") and prototypes.entity[name .. "-unlocked"] ~= nil then
        replace_map[name] = name .. "-unlocked"
    end
end

event_lib.add_lib({
    events = {
        on_research_finished = function(event)
            if lib_strings.starts_with(event.research.name, CONSTANTS.mod_name .. "-unlock-permanent-machines") then
                for _, surface in pairs(game.surfaces) do
                    for replace_from, replace_to in pairs(replace_map) do
                        local entities = surface.find_entities_filtered({name = replace_from, force = event.research.force})
                        for _, entity in ipairs(entities) do
                            surface.create_entity({name = replace_to, position = entity.position, direction = entity.direction, force = entity.force, mirror = entity.mirroring, quality = entity.quality, fast_replace = true, create_build_effect_smoke = false})
                        end
                    end
                end
            end
        end
    }
})