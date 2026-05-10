local CONSTANTS = require("common.constants")

local lib_strings = require("lib.strings")
local lib_vectors = require("lib.vectors")

local shy_machines = {}
for _, entity in pairs(prototypes.entity) do
    if lib_strings.starts_with(entity.name, CONSTANTS.mod_name) and lib_strings.ends_with(entity.name, "-shy") then
        shy_machines[entity.name] = true
    end
end

---@param event EventData.on_built_entity | EventData.on_robot_built_entity | EventData.on_space_platform_built_entity | EventData.script_raised_built
local function check_shyness(event)
    if not event.entity.valid then return end
    if not shy_machines[event.entity.name] then return end
    local bounding_box = lib_vectors.normalize_bounding_box(event.entity.bounding_box)
    local nearby_entities = event.entity.surface.find_entities_filtered{area = {{bounding_box.left_top.x - 1, bounding_box.left_top.y - 1}, {bounding_box.right_bottom.x + 1, bounding_box.right_bottom.y + 1}}}
    local eligible_entities = 0
    for _, entity in ipairs(nearby_entities) do
        if entity.force.name ~= "neutral" and entity.type ~= "character" then -- Filter out map entities and characters
            if entity.name ~= event.entity.name 
            or lib_vectors.normalize_map_position(entity.position).x ~= lib_vectors.normalize_map_position(event.entity.position).x
            or lib_vectors.normalize_map_position(entity.position).y ~= lib_vectors.normalize_map_position(event.entity.position).y then -- Filter out itself
                eligible_entities = eligible_entities + 1
            end
        end
    end
    if eligible_entities > 0 then
        event.entity.die()
    end
end

event_lib.add_lib({
    events = {
        on_built_entity = check_shyness,
        on_robot_built_entity = check_shyness,
        on_space_platform_built_entity = check_shyness,
        script_raised_built = check_shyness
    }
})