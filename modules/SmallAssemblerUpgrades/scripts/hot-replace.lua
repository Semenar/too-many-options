local CONSTANTS = require("common.constants")

local function do_hot_swap(entity)
    if entity.valid then
        local base_name
        if string.sub(entity.name, 1, string.len(CONSTANTS.mod_name) + 18) == CONSTANTS.mod_name .. "-small-assembler-1" then
            base_name = string.sub(entity.name, 1, string.len(CONSTANTS.mod_name) + 18)
        end
        if base_name ~= nil then
            local new_entity = entity.surface.create_entity({
                name = base_name .. "-faster-" .. tostring(storage.curr_small_assembler_speed_index),
                position = entity.position,
                direction = entity.direction,
                force = entity.force,
                mirror = entity.mirroring,
                quality = entity.quality,
                fast_replace = true,
                spill = false
            })
            -- Don't worry about removing machines from the table since I'm tired of coding this one thing and how many boilers/steam engines are you gonna place anyways
            -- It also only slows things down when a hotter steam tech is researched
            table.insert(storage.small_assemblers[base_name], new_entity)
            entity.destroy()
        end
    end
end

event_lib.add_lib(
    {
        on_init = function()
            storage.curr_small_assembler_speed_index = 0
            storage.small_assemblers = {
                [CONSTANTS.mod_name .. "-small-assembler-1"] = {}
            }
        end,
        events = {
            on_built_entity = function(event)
                do_hot_swap(event.entity)
            end,
            on_robot_built_entity = function(event)
                do_hot_swap(event.entity)
            end,
            on_space_platform_built_entity = function(event)
                do_hot_swap(event.entity)
            end,
            script_raised_built = function(event)
                do_hot_swap(event.entity)
            end,
            on_research_finished = function(event)
                if event.research.name == "faster-small-assemblers" then
                    storage.curr_small_assembler_speed_index = 1 + storage.curr_small_assembler_speed_index
                    local small_assembler_lists = {}
                    for k, small_assemblers in pairs(storage.small_assemblers) do
                        small_assembler_lists[k] = {}
                        for _, small_assembler in pairs(small_assemblers) do
                            table.insert(small_assembler_lists[k], small_assembler)
                        end
                    end
                    for _, small_assemblers in pairs(small_assembler_lists) do
                        for _, small_assembler in pairs(small_assemblers) do
                            do_hot_swap(small_assembler)
                        end
                    end
                end
            end
        }
    }
)
