local CONSTANTS = require("common.constants")

local matching_name = CONSTANTS.mod_name .. "-ore-furnace"

---@param event EventData.on_built_entity | EventData.on_robot_built_entity | EventData.on_space_platform_built_entity | EventData.script_raised_built
local function validate_building(event)
    if event.entity.valid and event.entity.prototype.fast_replaceable_group == matching_name then
        local replace_with = matching_name
        local ores = event.entity.surface.find_entities_filtered{area = event.entity.bounding_box, type = "resource"}
        if ores then
            for _, ore in ipairs(ores) do
                if prototypes.entity[matching_name.. "-specific-" .. ore.name] then
                    replace_with = matching_name .. "-specific-" .. ore.name
                end
            end
        end
        if replace_with ~= event.entity.name then
            local surface = event.entity.surface
            local creation_params = {name = replace_with, position = event.entity.position, direction = event.entity.direction, force = event.entity.force.name, mirror = event.entity.mirroring, quality = event.entity.quality.name, player = event.entity.last_user and event.entity.last_user.index, fast_replace = true, create_build_effect_smoke = false}
            event.entity.destroy()
            surface.create_entity(creation_params)
        end
    end
end

event_lib.add_lib({
    events = {
        on_built_entity = validate_building,
        on_robot_built_entity = validate_building,
        on_space_platform_built_entity = validate_building,
        script_raised_built = validate_building
    }
})