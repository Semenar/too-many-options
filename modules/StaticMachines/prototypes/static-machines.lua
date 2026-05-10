local CONSTANTS = require("common.constants")

local lib_recipe = require("lib.recipe")
local lib_prototypes = require("lib.prototypes")
local lib_strings = require("lib.strings")
local lib_energy = require("lib.energy")

---@param animation data.Animation4Way | data.Animation | data.WorkingVisualisation
local function make_animation_static(animation)
    if animation.north then make_animation_static(animation.north) end
    if animation.west then make_animation_static(animation.west) end
    if animation.south then make_animation_static(animation.south) end
    if animation.east then make_animation_static(animation.east) end
    if animation.animation then make_animation_static(animation.animation) end
    if animation.north_animation then make_animation_static(animation.north_animation) end
    if animation.west_animation then make_animation_static(animation.west_animation) end
    if animation.south_animation then make_animation_static(animation.south_animation) end
    if animation.east_animation then make_animation_static(animation.east_animation) end
    if animation.layers then
        for _, layer in ipairs(animation.layers) do
            make_animation_static(layer)
        end
    end
    animation.repeat_count = nil
    animation.frame_count = nil
    animation.frame_sequence = nil
end

local STATIC_MACHINE_SPEEDUP = 1.2

for _, category in ipairs({"furnace", "assembling-machine", "lab", "mining-drill"}) do
    if data.raw[category] then
        for _, machine in pairs(data.raw[category]) do
            if not machine.hidden and not lib_strings.starts_with(machine.name, CONSTANTS.mod_name) then
                ---@type data.FurnacePrototype | data.AssemblingMachinePrototype | data.LabPrototype | data.MiningDrillPrototype
                local static_machine = table.deepcopy(machine)
                static_machine.name = CONSTANTS.mod_name .. "-" .. static_machine.name .. "-static"
                static_machine.localised_name = {"entity-name." .. CONSTANTS.mod_name .. "-static-machine", {"entity-name." .. machine.name}}
                static_machine.localised_description = {"entity-description." .. CONSTANTS.mod_name .. "-static-machine"}
                if static_machine.minable then
                    if static_machine.minable.result == machine.name then
                        static_machine.minable.result = static_machine.name
                    end
                    if static_machine.minable.results then
                        for _, result in ipairs(static_machine.minable.results) do
                            if result.type == "item" and result.name == machine.name then
                                result.name = static_machine.name
                            end
                        end
                    end
                end
                static_machine.icons = static_machine.icons or {
                    {
                        icon = static_machine.icon,
                        icon_size = static_machine.icon_size or 64
                    }
                }
                table.insert(static_machine.icons, {
                    icon = "__core__/graphics/icons/technology/effect-constant/effect-constant-crafting-speed.png",
                    icon_size = 64
                })
                static_machine.icon = nil
                static_machine.icon_size = nil
                if static_machine.next_upgrade then static_machine.next_upgrade = CONSTANTS.mod_name .. "-" .. static_machine.next_upgrade .. "-static" end
                if static_machine.mining_speed then static_machine.mining_speed = static_machine.mining_speed * STATIC_MACHINE_SPEEDUP end
                if static_machine.crafting_speed then static_machine.crafting_speed = static_machine.crafting_speed * STATIC_MACHINE_SPEEDUP end
                if static_machine.researching_speed then static_machine.researching_speed = static_machine.researching_speed * STATIC_MACHINE_SPEEDUP end
                if static_machine.energy_usage then static_machine.energy_usage = lib_energy.convert_to_energy(util.parse_energy(static_machine.energy_usage) * STATIC_MACHINE_SPEEDUP) end
                if static_machine.energy_source then
                    if static_machine.energy_source.emissions_per_minute then
                        for emission, value in pairs(static_machine.energy_source.emissions_per_minute) do
                            static_machine.energy_source.emissions_per_minute[emission] = value * STATIC_MACHINE_SPEEDUP
                        end
                    end
                end
                for _, animation_key in ipairs({"on_animation", "off_animation"}) do
                    if static_machine[animation_key] then
                        make_animation_static(static_machine[animation_key])
                    end
                end
                for _, graphics_set in ipairs({"graphics_set", "graphics_set_flipped", "wet_mining_graphics_set"}) do
                    if static_machine[graphics_set] then
                        for _, animation_key in ipairs({"animation", "idle_animation"}) do
                            if static_machine[graphics_set][animation_key] then
                                make_animation_static(static_machine[graphics_set][animation_key])
                            end
                        end
                        if static_machine[graphics_set].working_visualisations then
                            for _, visualisation in ipairs(static_machine[graphics_set].working_visualisations) do
                                make_animation_static(visualisation)
                            end
                        end
                    end
                end

                ---@type data.ItemPrototype
                local machine_item = table.deepcopy(lib_prototypes.get_named_prototype("item", machine.name) or {
                    type = "item",
                    order = machine.name,
                    stack_size = 50,
                    weight = 20 * kg
                })
                machine_item.name = static_machine.name
                machine_item.localised_name = {"entity-name." .. CONSTANTS.mod_name .. "-static-machine", {"entity-name." .. machine.name}}
                machine_item.icons = machine_item.icons or {
                    {
                        icon = machine_item.icon,
                        icon_size = machine_item.icon_size or 64
                    }
                }
                table.insert(machine_item.icons, {
                    icon = "__core__/graphics/icons/technology/effect-constant/effect-constant-crafting-speed.png",
                    icon_size = 64
                })
                machine_item.icon = nil
                machine_item.icon_size = nil
                machine_item.place_result = static_machine.name
                machine_item.order = machine_item.order .. "-u[static]"

                data:extend({static_machine, machine_item})

                for _, recipe in pairs(data.raw.recipe) do
                    if recipe.results then
                        local produces_machine = false
                        for _, product in ipairs(recipe.results) do
                            if product.type == "item" and product.name == machine.name then
                                produces_machine = true
                            end
                        end

                        if produces_machine then
                            local static_recipe = table.deepcopy(recipe)
                            static_recipe.name = CONSTANTS.mod_name .. "-" .. static_recipe.name .. "-static"
                            static_recipe.localised_name = table.deepcopy(machine_item.localised_name)
                            static_recipe.ingredients = lib_recipe.ingredients_mult_specific(static_recipe.ingredients, {
                                ["item.iron-gear-wheel"] = 0.5,
                                ["item.iron-plate"] = 1.2,
                                ["item.steel-plate"] = 1.2,
                                ["item.stone-brick"] = 1.2,
                                ["item.concrete"] = 1.2
                            })
                            lib_recipe.replace_item_result(static_recipe, machine.name, static_machine.name)
                            data:extend({static_recipe})

                            for _, technology in pairs(data.raw.technology) do
                                if technology.effects then
                                    local technology_unlocks_recipe = false
                                    for _, effect in ipairs(technology.effects) do
                                        if effect.type == "unlock-recipe" and effect.recipe == recipe.name then
                                            technology_unlocks_recipe = true
                                        end
                                    end
                                    if technology_unlocks_recipe then
                                        table.insert(technology.effects, {type = "unlock-recipe", recipe = static_recipe.name})
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end