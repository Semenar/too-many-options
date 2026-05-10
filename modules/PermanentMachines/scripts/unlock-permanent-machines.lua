local CONSTANTS = require("common.constants")

local lib_strings = require("lib.strings")

local replace_map = {}
local replace_map_reverse = {}
for name, _ in pairs(prototypes.entity) do
    if lib_strings.starts_with(name, CONSTANTS.mod_name) and lib_strings.ends_with(name, "-permanent") and prototypes.entity[name .. "-unlocked"] ~= nil then
        replace_map[name] = name .. "-unlocked"
        replace_map_reverse[name .. "-unlocked"] = name
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
                            surface.create_entity({name = replace_to, position = entity.position, direction = entity.direction, force = entity.force, mirror = entity.mirroring, quality = entity.quality, fast_replace = true, spill = false, create_build_effect_smoke = false})
                        end
                    end
                end
            end
        end,
        on_robot_built_entity = function(event)
            if not event.entity.valid then return end
            if replace_map_reverse[event.entity.prototype.name] then
                event.entity.surface.create_entity({name = replace_map_reverse[event.entity.prototype.name], position = event.entity.position, direction = event.entity.direction, force = event.entity.force, mirror = event.entity.mirroring, quality = event.entity.quality, fast_replace = true, spill = false, create_build_effect_smoke = false})
            end
        end,
        on_space_platform_built_entity = function(event)
            if not event.entity.valid then return end
            if replace_map_reverse[event.entity.prototype.name] then
                event.entity.surface.create_entity({name = replace_map_reverse[event.entity.prototype.name], position = event.entity.position, direction = event.entity.direction, force = event.entity.force, mirror = event.entity.mirroring, quality = event.entity.quality, fast_replace = true, spill = false, create_build_effect_smoke = false})
            end
        end,
        script_raised_built = function(event)
            if not event.entity.valid then return end
            if replace_map_reverse[event.entity.prototype.name] then
                event.entity.surface.create_entity({name = replace_map_reverse[event.entity.prototype.name], position = event.entity.position, direction = event.entity.direction, force = event.entity.force, mirror = event.entity.mirroring, quality = event.entity.quality, fast_replace = true, spill = false, create_build_effect_smoke = false})
            end
        end
    }
})