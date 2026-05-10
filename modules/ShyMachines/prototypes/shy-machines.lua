local CONSTANTS = require("common.constants")

local lib_recipe = require("lib.recipe")
local lib_prototypes = require("lib.prototypes")
local lib_strings = require("lib.strings")
local lib_energy = require("lib.energy")
local lib_graphics = require("lib.graphics")
local lib_vectors = require("lib.vectors")

local lib_cache = require("lib.cache")
lib_cache.invalidate_cache()

local SHY_MACHINE_POWER_CONSUMPTION_MULTIPLIER = 0.4
local SHY_MACHINE_ANIMATION_SCALE = 0.95

for _, category in ipairs({"furnace", "assembling-machine", "lab", "mining-drill"}) do
    if data.raw[category] then
        for _, machine in pairs(data.raw[category]) do
            if not machine.hidden and not lib_strings.starts_with(machine.name, CONSTANTS.mod_name) then
                ---@type data.FurnacePrototype | data.AssemblingMachinePrototype | data.LabPrototype | data.MiningDrillPrototype
                local shy_machine = table.deepcopy(machine)
                shy_machine.name = CONSTANTS.mod_name .. "-" .. shy_machine.name .. "-shy"
                shy_machine.localised_name = {"entity-name." .. CONSTANTS.mod_name .. "-shy-machine", {"entity-name." .. machine.name}}
                shy_machine.localised_description = {"entity-description." .. CONSTANTS.mod_name .. "-shy-machine"}
                if shy_machine.minable then
                    if shy_machine.minable.result == machine.name then
                        shy_machine.minable.result = shy_machine.name
                    end
                    if shy_machine.minable.results then
                        for _, result in ipairs(shy_machine.minable.results) do
                            if result.type == "item" and result.name == machine.name then
                                result.name = shy_machine.name
                            end
                        end
                    end
                end
                shy_machine.icons = shy_machine.icons or {
                    {
                        icon = shy_machine.icon,
                        icon_size = shy_machine.icon_size or 64
                    }
                }
                table.insert(shy_machine.icons, {
                    icon = "__" .. CONSTANTS.mod_name .. "__/graphics/ShyMachines/constant-shy.png",
                    icon_size = 64
                })
                shy_machine.icon = nil
                shy_machine.icon_size = nil
                if shy_machine.next_upgrade then shy_machine.next_upgrade = CONSTANTS.mod_name .. "-" .. shy_machine.next_upgrade .. "-shy" end
                if shy_machine.energy_usage then shy_machine.energy_usage = lib_energy.convert_to_energy(util.parse_energy(shy_machine.energy_usage) * SHY_MACHINE_POWER_CONSUMPTION_MULTIPLIER) end
                if shy_machine.energy_source then
                    if shy_machine.energy_source.emissions_per_minute then
                        for emission, value in pairs(shy_machine.energy_source.emissions_per_minute) do
                            shy_machine.energy_source.emissions_per_minute[emission] = value * SHY_MACHINE_POWER_CONSUMPTION_MULTIPLIER
                        end
                    end
                end
                for _, animation_key in ipairs({"on_animation", "off_animation"}) do
                    if shy_machine[animation_key] then
                        lib_graphics.rescale_animation(shy_machine[animation_key], SHY_MACHINE_ANIMATION_SCALE)
                    end
                end
                for _, graphics_set in ipairs({"graphics_set", "graphics_set_flipped", "wet_mining_graphics_set"}) do
                    if shy_machine[graphics_set] then
                        for _, animation_key in ipairs({"animation", "idle_animation"}) do
                            if shy_machine[graphics_set][animation_key] then
                                lib_graphics.rescale_animation(shy_machine[graphics_set][animation_key], SHY_MACHINE_ANIMATION_SCALE)
                            end
                        end
                        if shy_machine[graphics_set].working_visualisations then
                            for _, visualisation in ipairs(shy_machine[graphics_set].working_visualisations) do
                                lib_graphics.rescale_animation(visualisation, SHY_MACHINE_ANIMATION_SCALE)
                            end
                        end
                        if shy_machine[graphics_set].frozen_patch then
                            if shy_machine[graphics_set].frozen_patch.sheets then
                                for _, sheet in ipairs(shy_machine[graphics_set].frozen_patch.sheets) do
                                    lib_graphics.rescale_animation(sheet, SHY_MACHINE_ANIMATION_SCALE)
                                end
                            elseif shy_machine[graphics_set].frozen_patch.sheet then lib_graphics.rescale_animation(shy_machine[graphics_set].frozen_patch.sheet, SHY_MACHINE_ANIMATION_SCALE)
                            elseif shy_machine[graphics_set].frozen_patch.north then
                                lib_graphics.rescale_animation(shy_machine[graphics_set].frozen_patch.north,SHY_MACHINE_ANIMATION_SCALE)
                                if shy_machine[graphics_set].frozen_patch.south then lib_graphics.rescale_animation(shy_machine[graphics_set].frozen_patch.south, SHY_MACHINE_ANIMATION_SCALE) end
                                if shy_machine[graphics_set].frozen_patch.west then lib_graphics.rescale_animation(shy_machine[graphics_set].frozen_patch.west, SHY_MACHINE_ANIMATION_SCALE) end
                                if shy_machine[graphics_set].frozen_patch.east then lib_graphics.rescale_animation(shy_machine[graphics_set].frozen_patch.east, SHY_MACHINE_ANIMATION_SCALE) end
                            else lib_graphics.rescale_animation(shy_machine[graphics_set].frozen_patch, SHY_MACHINE_ANIMATION_SCALE) end
                        end
                    end
                end
                if shy_machine.frozen_patch then lib_graphics.rescale_animation(shy_machine.frozen_patch, SHY_MACHINE_ANIMATION_SCALE) end

                ---@type data.ItemPrototype
                local machine_item = table.deepcopy(lib_prototypes.get_named_prototype("item", machine.name) or {
                    type = "item",
                    order = machine.name,
                    stack_size = 50,
                    weight = 20 * kg
                })
                machine_item.name = shy_machine.name
                machine_item.localised_name = table.deepcopy(shy_machine.localised_name)
                machine_item.icons = machine_item.icons or {
                    {
                        icon = machine_item.icon,
                        icon_size = machine_item.icon_size or 64
                    }
                }
                table.insert(machine_item.icons, {
                    icon = "__" .. CONSTANTS.mod_name .. "__/graphics/ShyMachines/constant-shy.png",
                    icon_size = 64
                })
                machine_item.icon = nil
                machine_item.icon_size = nil
                machine_item.place_result = shy_machine.name
                machine_item.order = machine_item.order .. "-u[shy]"

                data:extend({shy_machine, machine_item})

                for _, recipe in ipairs(lib_cache.product_to_recipe()["item." .. machine.name] or {}) do
                    local shy_recipe = table.deepcopy(recipe)
                    shy_recipe.name = CONSTANTS.mod_name .. "-" .. shy_recipe.name .. "-shy"
                    shy_recipe.localised_name = table.deepcopy(machine_item.localised_name)
                    shy_recipe.ingredients = lib_recipe.ingredients_mult_specific(shy_recipe.ingredients, {
                        ["item.electronic-circuit"] = 0.5,
                        ["item.advanced-circuit"] = 0.5,
                        ["item.processing-unit"] = 0.5
                    })
                    shy_recipe.ingredients = lib_recipe.ingredients_sum(shy_recipe.ingredients, {{
                        type = "item",
                        name = "copper-cable",
                        amount = math.floor(lib_vectors.bounding_box_perimeter(shy_machine.selection_box) + 0.5)
                    }})
                    lib_recipe.replace_item_result(shy_recipe, machine.name, shy_machine.name)
                    data:extend({shy_recipe})

                    for _, technology in ipairs(lib_cache.recipe_to_technology_unlock()[recipe.name] or {}) do
                        technology.effects = technology.effects or {}
                        table.insert(technology.effects, {type = "unlock-recipe", recipe = shy_recipe.name})
                    end
                end
            end
        end
    end
end