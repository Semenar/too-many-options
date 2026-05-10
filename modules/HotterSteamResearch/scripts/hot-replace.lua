local CONSTANTS = require("common.constants")

local function do_hot_swap(entity)
    if entity.valid then
        local base_name
        if string.sub(entity.name, 1, 6) == "boiler" then
            base_name = "boiler"
        end
        if string.sub(entity.name, 1, 12) == "steam-engine" then
            base_name = "steam-engine"
        end
        if string.sub(entity.name, 2+#CONSTANTS.mod_name, 20+#CONSTANTS.mod_name) == "boiler-permanent" then
            base_name = "boiler-permanent"
        end
        if string.sub(entity.name, 2+#CONSTANTS.mod_name, 23+#CONSTANTS.mod_name) == "steam-engine-permanent" then
            base_name = "steam-engine-permanent"
        end
        if base_name ~= nil then
            local new_entity =
                entity.surface.create_entity(
                {
                    name = base_name .. "-hotter-" .. tostring(storage.curr_steam_heat_index),
                    position = entity.position,
                    direction = entity.direction,
                    mirror = entity.mirroring,
                    fast_replace = true
                }
            )
            -- Don't worry about removing machines from the table since I'm tired of coding this one thing and how many boilers/steam engines are you gonna place anyways
            -- It also only slows things down when a hotter steam tech is researched
            table.insert(storage.steam_machines[base_name], new_entity)
            entity.destroy()
        end
    end
end

event_lib.add_lib(
    {
        on_init = function()
            storage.curr_steam_heat_index = 0
            storage.steam_machines = {
                boiler = {},
                ["steam-engine"] = {},
                ["boiler-permanent"] = {},
                ["steam-engine-permanent"] = {},
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
                if string.sub(event.research.name, 1, 12) == "hotter-steam" then
                    storage.curr_steam_heat_index = 1 + storage.curr_steam_heat_index
                    local steam_machine_lists = {}
                    for k, steam_machines in pairs(storage.steam_machines) do
                        steam_machine_lists[k] = {}
                        for _, steam_machine in pairs(steam_machines) do
                            table.insert(steam_machine_lists[k], steam_machine)
                        end
                    end
                    for _, steam_machines in pairs(steam_machine_lists) do
                        for _, steam_machine in pairs(steam_machines) do
                            do_hot_swap(steam_machine)
                        end
                    end
                end
            end
        }
    }
)
