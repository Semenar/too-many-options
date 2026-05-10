local CONSTANTS = require("common.constants")

local util = require("util")

local lib_prototypes = require("lib.prototypes")
local lib_vectors = require("lib.vectors")
local lib_energy = require("lib.energy")
local lib_recipe = require("lib.recipe")
local lib_cache = require("lib.cache")
lib_cache.invalidate_cache()

local longer_inserters_spec = {
    {
        name = "longer-inserter",
        tint = {r = 1, g = 0.75, b = 0.75},
        additional_length = 1,
        speed_multiplier = 0.85,
        power_draw_multiplier = 1.5
    },
    {
        name = "even-longer-inserter",
        tint = {r = 0.75, g = 0.55, b = 0.55},
        additional_length = 2,
        speed_multiplier = 0.7,
        power_draw_multiplier = 2.2
    },
    {
        name = "very-long-inserter",
        tint = {r = 0.55, g = 0.4, b = 0.4},
        additional_length = 3,
        speed_multiplier = 0.6,
        power_draw_multiplier = 3
    },
    {
        name = "extremely-long-inserter",
        tint = {r = 0.4, g = 0.3, b = 0.3},
        additional_length = 4,
        speed_multiplier = 0.5,
        power_draw_multiplier = 4
    },
    {
        name = "ridiculously-long-inserter",
        tint = {r = 0.3, g = 0.2, b = 0.2},
        additional_length = 5,
        speed_multiplier = 0.4,
        power_draw_multiplier = 6
    },
    {
        name = "longest-inserter",
        tint = {r = 0.2, g = 0.1, b = 0.1},
        additional_length = 6,
        speed_multiplier = 0.3,
        power_draw_multiplier = 10
    }
}

local base_prototype = "long-handed-inserter"

local original_machine = lib_prototypes.get_named_prototype("entity", base_prototype)
if original_machine then
    for i, spec in ipairs(longer_inserters_spec) do
        ---@type data.InserterPrototype
        local machine = table.deepcopy(original_machine)

        machine.name = CONSTANTS.mod_name .. "-" .. spec.name
        util.recursive_tint(machine, spec.tint)
        machine.fast_replaceable_group = nil

        machine.order = CONSTANTS.mod_name .. "-longer-inserter-" .. spec.additional_length

        machine.minable = machine.minable or {mining_time = 0.2}
        machine.minable.results = nil
        machine.minable.result = machine.name

        if not machine.icons then machine.icons = {{icon = machine.icon, icon_size = machine.icon_size or 64}} end
        for _, icon in ipairs(machine.icons) do
            if icon.tint then icon.tint = lib_vectors.color_mult(icon.tint, spec.tint) else icon.tint = spec.tint end
        end
        machine.icon = nil
        machine.icon_size = nil
        
        machine.pickup_position = lib_vectors.normalize_map_position(machine.pickup_position)
        machine.pickup_position.y = machine.pickup_position.y - spec.additional_length

        machine.insert_position = lib_vectors.normalize_map_position(machine.insert_position)
        machine.insert_position.y = machine.insert_position.y + spec.additional_length

        machine.hand_size = (machine.hand_size or 0.75) + 0.75 * spec.additional_length

        machine.energy_per_movement = lib_energy.convert_to_energy(util.parse_energy(machine.energy_per_movement or "0W") * spec.power_draw_multiplier)
        machine.energy_per_rotation = lib_energy.convert_to_energy(util.parse_energy(machine.energy_per_rotation or "0W") * spec.power_draw_multiplier)
        if machine.energy_source and machine.energy_source.drain then machine.energy_source.drain = lib_energy.convert_to_energy(util.parse_energy(machine.energy_source.drain) * spec.power_draw_multiplier) end
        machine.extension_speed = machine.extension_speed * (2 + spec.additional_length) / 2.
        machine.rotation_speed = machine.rotation_speed * spec.speed_multiplier

        ---@type data.ItemPrototype
        local machine_item = table.deepcopy(lib_prototypes.get_named_prototype("item", base_prototype) or {
            type = "item",
            order = machine.name,
            stack_size = 50,
            weight = 20 * kg
        })
        machine_item.name = machine.name
        machine_item.localised_name = {"entity-name." .. machine.name}
        machine_item.icons = machine_item.icons or {
            {
                icon = machine_item.icon,
                icon_size = machine_item.icon_size or 64
            }
        }
        machine_item.icon = nil
        machine_item.icon_size = nil
        for _, icon in ipairs(machine_item.icons) do
            if icon.tint then icon.tint = lib_vectors.color_mult(icon.tint, spec.tint) else icon.tint = spec.tint end
        end

        machine_item.place_result = machine.name
        machine_item.order = machine_item.order .. "-u[longer]-" .. spec.additional_length

        data:extend({machine, machine_item})

        for _, original_recipe in ipairs(lib_cache.product_to_recipe()["item." .. base_prototype] or {}) do
            local recipe = table.deepcopy(original_recipe)
            recipe.name = machine.name .. "-" .. recipe.name
            if original_recipe.name == base_prototype then recipe.name = machine.name end
            local previous_inserter = base_prototype
            if i > 1 then previous_inserter =  CONSTANTS.mod_name .. "-" .. longer_inserters_spec[i-1].name end
            lib_recipe.replace_item_ingredient(recipe, "inserter", previous_inserter)
            lib_recipe.replace_item_result(recipe, base_prototype, machine.name)

            recipe.localised_name = lib_recipe.get_localised_name(recipe)

            data:extend({recipe})

            for _, technology in ipairs(lib_cache.recipe_to_technology_unlock()[original_recipe.name] or {}) do
                technology.effects = technology.effects or {}
                table.insert(technology.effects, {
                    type = "unlock-recipe",
                    recipe = recipe.name
                })
            end
        end
    end
end