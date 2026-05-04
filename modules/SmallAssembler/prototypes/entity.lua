local CONSTANTS = require("common.constants")

local lib_graphics = require("lib.graphics")

for i=1,3 do
    if data.raw["assembling-machine"]["assembling-machine-" .. i] then
        local entity = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-" .. i])

        entity.name = CONSTANTS.mod_name .. "-small-assembler-" .. i
        entity.icon = "__" .. CONSTANTS.mod_name .. "__/graphics/SmallAssembler/small-assembler-" .. i .. ".png"
        if entity.minable then
            entity.minable.result = entity.name
        end
        entity.max_health = entity.max_health * 0.5
        if entity.circuit_wire_max_distance then
            entity.circuit_wire_max_distance = entity.circuit_wire_max_distance * 2 / 3.
        end
        if entity.icon_draw_specification and entity.icon_draw_specification.shift then
            if entity.icon_draw_specification.shift[1] ~= nil then entity.icon_draw_specification.shift[1] = entity.icon_draw_specification.shift[1] * 2 / 3. end
            if entity.icon_draw_specification.shift[2] ~= nil then entity.icon_draw_specification.shift[2] = entity.icon_draw_specification.shift[2] * 2 / 3. end
            if entity.icon_draw_specification.shift.x ~= nil then entity.icon_draw_specification.shift.x = entity.icon_draw_specification.shift.x * 2 / 3. end
            if entity.icon_draw_specification.shift.y ~= nil then entity.icon_draw_specification.shift.y = entity.icon_draw_specification.shift.y * 2 / 3. end
        end
        if entity.alert_icon_shift then
            if entity.alert_icon_shift[1] ~= nil then entity.alert_icon_shift[1] = entity.alert_icon_shift[1] * 2 / 3. end
            if entity.alert_icon_shift[2] ~= nil then entity.alert_icon_shift[2] = entity.alert_icon_shift[2] * 2 / 3. end
            if entity.alert_icon_shift.x ~= nil then entity.alert_icon_shift.x = entity.alert_icon_shift.x * 2 / 3. end
            if entity.alert_icon_shift.y ~= nil then entity.alert_icon_shift.y = entity.alert_icon_shift.y * 2 / 3. end
        end
        if entity.fluid_boxes then
            for _, fluidbox in ipairs(entity.fluid_boxes) do
                for _, connection in ipairs(fluidbox.pipe_connections) do
                    local pipe_shift = {0, 0}
                    if connection.direction == defines.direction.north or connection.direction == defines.direction.east then pipe_shift = {-0.5, 0.5} end
                    if connection.direction == defines.direction.south or connection.direction == defines.direction.west then pipe_shift = {0.5, -0.5} end
                    if connection.position then
                        if connection.position[1] ~= nil then connection.position[1] = connection.position[1] + pipe_shift[1] end
                        if connection.position[2] ~= nil then connection.position[2] = connection.position[2] + pipe_shift[2] end
                        if connection.position.x ~= nil then connection.position.x = connection.position.x + pipe_shift[1] end
                        if connection.position.y ~= nil then connection.position.y = connection.position.y + pipe_shift[2] end
                    end
                    if connection.positions then
                        for _, position in ipairs(connection.positions) do
                            if position[1] ~= nil then position[1] = position[1] + pipe_shift[1] end
                            if position[2] ~= nil then position[2] = position[2] + pipe_shift[2] end
                            if position.x ~= nil then position.x = position.x + pipe_shift[1] end
                            if position.y ~= nil then position.y = position.y + pipe_shift[2] end
                        end
                    end
                end
            end
        end
        if i < 3 then
            entity.next_upgrade = CONSTANTS.mod_name .. "-small-assembler-" .. (i + 1)
        else
            entity.next_upgrade = nil
        end
        entity.collision_box = {{-0.8, -0.8}, {0.8, 0.8}}
        entity.selection_box = {{-1, -1}, {1, 1}}
        entity.fast_replaceable_group = CONSTANTS.mod_name .. "-small-assembler"
        if entity.graphics_set then
            for _, animation in ipairs({entity.graphics_set.animation, entity.graphics_set.idle_animation}) do
                if animation then
                    if animation.north then
                        lib_graphics.rescale_animation(animation.north, 2 / 3.)
                        if animation.south then lib_graphics.rescale_animation(animation.south, 2 / 3.) end
                        if animation.west then lib_graphics.rescale_animation(animation.west, 2 / 3.) end
                        if animation.east then lib_graphics.rescale_animation(animation.east, 2 / 3.) end
                    else
                        lib_graphics.rescale_animation(animation, 2 / 3.)
                    end
                end
            end
        end
        entity.crafting_speed = entity.crafting_speed * (0.1 + 0.3 * i)
        if i == 3 and entity.module_slots then
            entity.module_slots = entity.module_slots - 1
        end
        entity.allowed_effects = {"consumption", "speed", "pollution", "quality"}

        data:extend({entity})
    end
end