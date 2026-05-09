-- COPPER ORES --
-- Bornite - brown-red, 2x richer, only appears north of spawn
-- Chalcopyrite - brassy-golden, 2x richer, separated into three grades (proportions 5-3-1): first is smeltable to plates directly, second can be converted to the first in an assembler, third can be smelted into wires or converted into the second with sulfuric acid in a chemical plant
-- Tetrahedrite - slightly bluish?, 1.5x less plentiful, can be also used as fuel (6 MJ)
-- Tenorite - blackish, 4x more plentiful, is invisible on the map
-- Enargite - gray?, 5x more plentiful, mines 4x faster, cannot be built upon
-- Chrysocolla - blue, 3x more plentiful, mines 50% faster, spoils into nothing in 30 minutes
-- Malachite - green-ish, 1000x less plentiful, 10x harder to mine, mined in batches of 100

require ("util")

local CONSTANTS = require("common.constants")

local lib_vectors = require("lib.vectors")

local resource_autoplace = require("resource-autoplace")
local item_sounds = require("__base__.prototypes.item_sounds")
require("__base__/prototypes/factoriopedia-util")

local BASE_DENSITY = 8 / 6.
local BASE_MINING_TIME = 1

if data.raw.resource["copper-ore"] and data.raw["autoplace-control"]["copper-ore"] then
    resource_autoplace.initialize_patch_set(CONSTANTS.mod_name .. "-copper-bornite", false)
    resource_autoplace.initialize_patch_set(CONSTANTS.mod_name .. "-copper-chalcopyrite", false)
    resource_autoplace.initialize_patch_set(CONSTANTS.mod_name .. "-copper-tetrahedrite", false)
    resource_autoplace.initialize_patch_set(CONSTANTS.mod_name .. "-copper-tenorite", false)
    resource_autoplace.initialize_patch_set(CONSTANTS.mod_name .. "-copper-enargite", false)
    resource_autoplace.initialize_patch_set(CONSTANTS.mod_name .. "-copper-chrysocolla", false)
    resource_autoplace.initialize_patch_set(CONSTANTS.mod_name .. "-copper-malachite", false)

    ---@param name string
    ---@param tint Color
    ---@param mining_time_mult double
    ---@param density_mult double
    ---@param mining_result? (data.FluidProductPrototype|data.ItemProductPrototype)[]
    local clone_copper = function(name, tint, mining_time_mult, density_mult, mining_result)
        local ore = table.deepcopy(data.raw.resource["copper-ore"])
        ore.name = name
        ore.icons = {
            {
                icon = ore.icon,
                tint = tint
            }
        }
        ore.icon = nil
        ore.order = ore.order .. "-" .. name
        ore.subgroup = CONSTANTS.mod_name .. "-ores"
        ore.minable = {
            mining_particle = "copper-ore-particle",
            mining_time = BASE_MINING_TIME * mining_time_mult,
            results = mining_result or {
                {
                    type = "item",
                    name = "copper-ore",
                    amount = 1
                }
            }
        }
        ore.autoplace = resource_autoplace.resource_autoplace_settings
        {
            name = name,
            order = "b",
            base_density = BASE_DENSITY * density_mult,
            has_starting_area_placement = false,
            regular_rq_factor_multiplier = 1.1
        }
        if ore.stages and ore.stages.sheet then
            ore.stages.sheet.tint = tint
        end
        ore.factoriopedia_simulation = {init = make_resource(name)}
        ore.map_color = lib_vectors.color_mult(ore.map_color, tint)
        ore.mining_visualisation_tint = lib_vectors.color_mult(ore.mining_visualisation_tint, tint)

        local autoplace_control = table.deepcopy(data.raw["autoplace-control"]["copper-ore"])
        autoplace_control.name = name
        autoplace_control.order = autoplace_control.order .. "-" .. name
        autoplace_control.localised_name = {"", "[entity=" .. name .. "] ", {"entity-name." .. name}}

        for _, planet in pairs(data.raw.planet) do
            if planet.map_gen_settings and planet.map_gen_settings.autoplace_settings and planet.map_gen_settings.autoplace_settings.entity and planet.map_gen_settings.autoplace_settings.entity.settings and planet.map_gen_settings.autoplace_settings.entity.settings["copper-ore"] ~= nil then
                if planet.map_gen_settings.autoplace_controls then
                    planet.map_gen_settings.autoplace_controls[name] = {}
                end
                planet.map_gen_settings.autoplace_settings.entity.settings[name] = {}
            end
        end

        data:extend({ore, autoplace_control})
    end

    clone_copper(CONSTANTS.mod_name .. "-copper-bornite", {r=0.4, g=0.4, b=0.2}, 1, 2)
    data.raw.resource[CONSTANTS.mod_name .. "-copper-bornite"].autoplace.probability_expression = data.raw.resource[CONSTANTS.mod_name .. "-copper-bornite"].autoplace.probability_expression .. " * (y < 0)"

    local chalcopyrite_tint = {r=0.6, g=0.7, b=0.3}
    clone_copper(CONSTANTS.mod_name .. "-copper-chalcopyrite", chalcopyrite_tint, 1, 2, {
        {
            type = "item",
            name = CONSTANTS.mod_name .. "-copper-chalcopyrite-grade-1",
            amount = 1,
            probability = 5. / 9.
        },
        {
            type = "item",
            name = CONSTANTS.mod_name .. "-copper-chalcopyrite-grade-2",
            amount = 1,
            probability = 3. / 9.
        },
        {
            type = "item",
            name = CONSTANTS.mod_name .. "-copper-chalcopyrite-grade-3",
            amount = 1,
            probability = 1. / 9.
        }
    })
    data:extend({
        {
            type = "item",
            name = CONSTANTS.mod_name .. "-copper-chalcopyrite-grade-1",
            icons = {
                {
                    icon = "__base__/graphics/icons/copper-ore.png",
                    tint = chalcopyrite_tint
                }
            },
            pictures =
            {
                {size = 64, filename = "__base__/graphics/icons/copper-ore.png", scale = 0.5, mipmap_count = 4, tint = chalcopyrite_tint},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-1.png", scale = 0.5, mipmap_count = 4, tint = chalcopyrite_tint},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-2.png", scale = 0.5, mipmap_count = 4, tint = chalcopyrite_tint},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-3.png", scale = 0.5, mipmap_count = 4, tint = chalcopyrite_tint}
            },
            subgroup = "raw-resource",
            order = "f[copper-ore]-chalcopyrite-1",
            inventory_move_sound = item_sounds.resource_inventory_move,
            pick_sound = item_sounds.resource_inventory_pickup,
            drop_sound = item_sounds.resource_inventory_move,
            stack_size = 50,
            weight = 2 * kg
        },
        {
            type = "item",
            name = CONSTANTS.mod_name .. "-copper-chalcopyrite-grade-2",
            icons = {
                {
                    icon = "__base__/graphics/icons/copper-ore.png",
                    tint = lib_vectors.color_mult(chalcopyrite_tint, {r=0.7, g=0.7, b=0.7})
                }
            },
            pictures =
            {
                {size = 64, filename = "__base__/graphics/icons/copper-ore.png", scale = 0.5, mipmap_count = 4, tint = lib_vectors.color_mult(chalcopyrite_tint, {r=0.7, g=0.7, b=0.7})},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-1.png", scale = 0.5, mipmap_count = 4, tint = lib_vectors.color_mult(chalcopyrite_tint, {r=0.7, g=0.7, b=0.7})},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-2.png", scale = 0.5, mipmap_count = 4, tint = lib_vectors.color_mult(chalcopyrite_tint, {r=0.7, g=0.7, b=0.7})},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-3.png", scale = 0.5, mipmap_count = 4, tint = lib_vectors.color_mult(chalcopyrite_tint, {r=0.7, g=0.7, b=0.7})}
            },
            subgroup = "raw-resource",
            order = "f[copper-ore]-chalcopyrite-2",
            inventory_move_sound = item_sounds.resource_inventory_move,
            pick_sound = item_sounds.resource_inventory_pickup,
            drop_sound = item_sounds.resource_inventory_move,
            stack_size = 50,
            weight = 2 * kg
        },
        {
            type = "item",
            name = CONSTANTS.mod_name .. "-copper-chalcopyrite-grade-3",
            icons = {
                {
                    icon = "__base__/graphics/icons/copper-ore.png",
                    tint = lib_vectors.color_mult(chalcopyrite_tint, {r=0.4, g=0.4, b=0.4})
                }
            },
            pictures =
            {
                {size = 64, filename = "__base__/graphics/icons/copper-ore.png", scale = 0.5, mipmap_count = 4, tint = lib_vectors.color_mult(chalcopyrite_tint, {r=0.4, g=0.4, b=0.4})},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-1.png", scale = 0.5, mipmap_count = 4, tint = lib_vectors.color_mult(chalcopyrite_tint, {r=0.4, g=0.4, b=0.4})},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-2.png", scale = 0.5, mipmap_count = 4, tint = lib_vectors.color_mult(chalcopyrite_tint, {r=0.4, g=0.4, b=0.4})},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-3.png", scale = 0.5, mipmap_count = 4, tint = lib_vectors.color_mult(chalcopyrite_tint, {r=0.4, g=0.4, b=0.4})}
            },
            subgroup = "raw-resource",
            order = "f[copper-ore]-chalcopyrite-3",
            inventory_move_sound = item_sounds.resource_inventory_move,
            pick_sound = item_sounds.resource_inventory_pickup,
            drop_sound = item_sounds.resource_inventory_move,
            stack_size = 50,
            weight = 2 * kg
        },
        {
            type = "recipe",
            name = CONSTANTS.mod_name .. "-chalcopyrite-smelting",
            category = "smelting",
            enabled = true,
            auto_recycle = false,
            energy_required = 3.2,
            ingredients = {{type = "item", name = CONSTANTS.mod_name .. "-copper-chalcopyrite-grade-1", amount = 1}},
            results = {{type="item", name="copper-plate", amount=1}},
            main_product = "copper-plate",
            allow_productivity = true
        },
        {
            type = "recipe",
            name = CONSTANTS.mod_name .. "-chalcopyrite-sorting",
            category = "crafting",
            enabled = true,
            auto_recycle = false,
            energy_required = 6.4,
            ingredients = {{type = "item", name = CONSTANTS.mod_name .. "-copper-chalcopyrite-grade-2", amount = 1}},
            results = {{type = "item", name = CONSTANTS.mod_name .. "-copper-chalcopyrite-grade-1", amount = 1}},
            main_product = CONSTANTS.mod_name .. "-copper-chalcopyrite-grade-1",
            allow_productivity = true,
            allow_decomposition = false
        },
        {
            type = "recipe",
            name = CONSTANTS.mod_name .. "-chalcopyrite-cleaning",
            category = "chemistry",
            enabled = false,
            auto_recycle = false,
            energy_required = 6.4,
            ingredients = {
                {type = "item", name = CONSTANTS.mod_name .. "-copper-chalcopyrite-grade-3", amount = 1},
                {type = "fluid", name = "sulfuric-acid", amount = 2}
            },
            results = {{type = "item", name = CONSTANTS.mod_name .. "-copper-chalcopyrite-grade-2", amount = 1}},
            main_product = CONSTANTS.mod_name .. "-copper-chalcopyrite-grade-2",
            crafting_machine_tint = -- from battery
            {
                primary = {r = 0.965, g = 0.482, b = 0.338, a = 1.000}, -- #f67a56ff
                secondary = {r = 0.831, g = 0.560, b = 0.222, a = 1.000}, -- #d38e38ff
                tertiary = {r = 0.728, g = 0.818, b = 0.443, a = 1.000}, -- #b9d070ff
                quaternary = {r = 0.939, g = 0.763, b = 0.191, a = 1.000}, -- #efc230ff
            },
            allow_productivity = true,
            allow_decomposition = false
        },
        {
            type = "recipe",
            name = CONSTANTS.mod_name .. "-chalcopyrite-extruding",
            category = "smelting",
            enabled = true,
            auto_recycle = false,
            energy_required = 3.2,
            ingredients = {{type = "item", name = CONSTANTS.mod_name .. "-copper-chalcopyrite-grade-3", amount = 1}},
            results = {{type="item", name="copper-cable", amount=1}},
            main_product = "copper-cable",
            allow_productivity = true,
            allow_decomposition = false
        },
    })
    if data.raw.technology["sulfur-processing"] then
        data.raw.technology["sulfur-processing"].effects = data.raw.technology["sulfur-processing"].effects or {}
        table.insert(data.raw.technology["sulfur-processing"].effects, {type = "unlock-recipe", recipe = CONSTANTS.mod_name .. "-chalcopyrite-cleaning"})
    end

    local tetrahedrite_tint = {r=0.4, g=0.7, b=1}
    clone_copper(CONSTANTS.mod_name .. "-copper-tetrahedrite", tetrahedrite_tint, 1, 1. / 1.5, {
        {
            type = "item",
            name = CONSTANTS.mod_name .. "-copper-tetrahedrite",
            amount = 1
        }
    })
    data:extend({
        {
            type = "item",
            name = CONSTANTS.mod_name .. "-copper-tetrahedrite",
            icons = {
                {
                    icon = "__base__/graphics/icons/copper-ore.png",
                    tint = tetrahedrite_tint
                }
            },
            pictures =
            {
                {size = 64, filename = "__base__/graphics/icons/copper-ore.png", scale = 0.5, mipmap_count = 4, tint = tetrahedrite_tint},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-1.png", scale = 0.5, mipmap_count = 4, tint = tetrahedrite_tint},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-2.png", scale = 0.5, mipmap_count = 4, tint = tetrahedrite_tint},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-3.png", scale = 0.5, mipmap_count = 4, tint = tetrahedrite_tint}
            },
            subgroup = "raw-resource",
            order = "f[copper-ore]-tetrahedrite",
            inventory_move_sound = item_sounds.resource_inventory_move,
            pick_sound = item_sounds.resource_inventory_pickup,
            drop_sound = item_sounds.resource_inventory_move,
            stack_size = 50,
            weight = 2 * kg,
            fuel_category = "chemical",
            fuel_value = "6MJ"
        },
        {
            type = "recipe",
            name = CONSTANTS.mod_name .. "-tetrahedrite-smelting",
            category = "smelting",
            enabled = true,
            auto_recycle = false,
            energy_required = 3.2,
            ingredients = {{type = "item", name = CONSTANTS.mod_name .. "-copper-tetrahedrite", amount = 1}},
            results = {{type="item", name="copper-plate", amount=1}},
            main_product = "copper-plate",
            allow_productivity = true
        }
    })

    clone_copper(CONSTANTS.mod_name .. "-copper-tenorite", {r=0.2, g=0.3, b=0.4}, 1, 4)
    data.raw.resource[CONSTANTS.mod_name .. "-copper-tenorite"].map_color = {r=1, g=1, b=1, a=0}

    clone_copper(CONSTANTS.mod_name .. "-copper-enargite", {r=0.2, g=0.5, b=0.8}, 1. / 4, 5)
    data.raw.resource[CONSTANTS.mod_name .. "-copper-enargite"].collision_box = {{-0.45, -0.45}, {0.45, 0.45}}
    data.raw.resource[CONSTANTS.mod_name .. "-copper-enargite"].collision_mask = {
        layers = {item=true, meltable=true, object=true, player=true, water_tile=true, is_object=true, is_lower_object=true}
    }

    local chrysocolla_tint = {r=0.2, g=0.7, b=1}
    clone_copper(CONSTANTS.mod_name .. "-copper-chrysocolla", chrysocolla_tint, 1 / 1.5, 3, {
        {
            type = "item",
            name = CONSTANTS.mod_name .. "-copper-chrysocolla",
            amount = 1
        }
    })
    data:extend({
        {
            type = "item",
            name = CONSTANTS.mod_name .. "-copper-chrysocolla",
            icons = {
                {
                    icon = "__base__/graphics/icons/copper-ore.png",
                    tint = chrysocolla_tint
                }
            },
            pictures =
            {
                {size = 64, filename = "__base__/graphics/icons/copper-ore.png", scale = 0.5, mipmap_count = 4, tint = chrysocolla_tint},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-1.png", scale = 0.5, mipmap_count = 4, tint = chrysocolla_tint},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-2.png", scale = 0.5, mipmap_count = 4, tint = chrysocolla_tint},
                {size = 64, filename = "__base__/graphics/icons/copper-ore-3.png", scale = 0.5, mipmap_count = 4, tint = chrysocolla_tint}
            },
            subgroup = "raw-resource",
            order = "f[copper-ore]-chrysocolla",
            inventory_move_sound = item_sounds.resource_inventory_move,
            pick_sound = item_sounds.resource_inventory_pickup,
            drop_sound = item_sounds.resource_inventory_move,
            stack_size = 50,
            weight = 2 * kg,
            spoil_ticks = 30 * minute
        },
        {
            type = "recipe",
            name = CONSTANTS.mod_name .. "-chrysocolla-smelting",
            category = "smelting",
            enabled = true,
            auto_recycle = false,
            energy_required = 3.2,
            ingredients = {{type = "item", name = CONSTANTS.mod_name .. "-copper-chrysocolla", amount = 1}},
            results = {{type="item", name="copper-plate", amount=1}},
            main_product = "copper-plate",
            allow_productivity = true
        }
    })

    clone_copper(CONSTANTS.mod_name .. "-copper-malachite", {r=0.3, g=0.8, b=0.8}, 10, 0.1,  {
        {
            type = "item",
            name = "copper-ore",
            amount = 100
        }
    })
    data.raw.resource[CONSTANTS.mod_name .. "-copper-malachite"].autoplace.richness_expression = data.raw.resource[CONSTANTS.mod_name .. "-copper-malachite"].autoplace.richness_expression .. " * 0.01"
end