-- IRON ORES --
-- Pyrite - light brass, 3x richer, 1% chance to mine stone in addition
-- Hematite - red, 10x richer, 5x harder to mine
-- Siderite - yellowish, 3x less rich, 2x easier to mine
-- Magnetite - darker, 3x harder to mine, smelts 1-1 into steel
-- Limonite - brown, 1.5x harder to mine, can be smelted directly or converted to copper (with 50% loss)
-- Goethite - dark gray, 2x harder to mine and 2x wider in both directions
-- Taconite - gray, 2x richer, 1% chance to produce 100 iron, the rest does nothing

require ("util")

local CONSTANTS = require("common.constants")

local lib_vectors = require("lib.vectors")

local resource_autoplace = require("resource-autoplace")
local item_sounds = require("__base__.prototypes.item_sounds")
require("__base__/prototypes/factoriopedia-util")

local BASE_DENSITY = 10 / 6.
local BASE_MINING_TIME = 1

if data.raw.resource["iron-ore"] and data.raw["autoplace-control"]["iron-ore"] then
    resource_autoplace.initialize_patch_set(CONSTANTS.mod_name .. "-iron-pyrite", false)
    resource_autoplace.initialize_patch_set(CONSTANTS.mod_name .. "-iron-hematite", false)
    resource_autoplace.initialize_patch_set(CONSTANTS.mod_name .. "-iron-siderite", false)
    resource_autoplace.initialize_patch_set(CONSTANTS.mod_name .. "-iron-magnetite", false)
    resource_autoplace.initialize_patch_set(CONSTANTS.mod_name .. "-iron-limonite", false)
    resource_autoplace.initialize_patch_set(CONSTANTS.mod_name .. "-iron-goethite", false)
    resource_autoplace.initialize_patch_set(CONSTANTS.mod_name .. "-iron-taconite", false)

    ---@param name string
    ---@param tint Color
    ---@param mining_time_mult number
    ---@param density_mult number
    ---@param mining_result? (data.FluidProductPrototype|data.ItemProductPrototype)[]
    local clone_iron = function(name, tint, mining_time_mult, density_mult, mining_result)
        local ore = table.deepcopy(data.raw.resource["iron-ore"])
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
            mining_particle = "iron-ore-particle",
            mining_time = BASE_MINING_TIME * mining_time_mult,
            results = mining_result or {
                {
                    type = "item",
                    name = name,
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

        local autoplace_control = table.deepcopy(data.raw["autoplace-control"]["iron-ore"])
        autoplace_control.name = name
        autoplace_control.order = autoplace_control.order .. "-" .. name
        autoplace_control.localised_name = {"", "[entity=" .. name .. "] ", {"entity-name." .. name}}

        for _, planet in pairs(data.raw.planet) do
            if planet.map_gen_settings and planet.map_gen_settings.autoplace_settings and planet.map_gen_settings.autoplace_settings.entity and planet.map_gen_settings.autoplace_settings.entity.settings and planet.map_gen_settings.autoplace_settings.entity.settings["iron-ore"] ~= nil then
                if planet.map_gen_settings.autoplace_controls then
                    planet.map_gen_settings.autoplace_controls[name] = {}
                end
                planet.map_gen_settings.autoplace_settings.entity.settings[name] = {}
            end
        end

        data:extend({ore, autoplace_control})
    end

    local clone_iron_item = function(name, tint)
        data:extend({
            {
                type = "item",
                name = CONSTANTS.mod_name .. "-iron-" .. name,
                localised_name = {"entity-name." .. CONSTANTS.mod_name .. "-iron-" .. name},
                icons = {
                    {
                        icon = "__base__/graphics/icons/iron-ore.png",
                        tint = tint
                    }
                },
                pictures =
                {
                    {size = 64, filename = "__base__/graphics/icons/iron-ore.png", scale = 0.5, mipmap_count = 4, tint = tint},
                    {size = 64, filename = "__base__/graphics/icons/iron-ore-1.png", scale = 0.5, mipmap_count = 4, tint = tint},
                    {size = 64, filename = "__base__/graphics/icons/iron-ore-2.png", scale = 0.5, mipmap_count = 4, tint = tint},
                    {size = 64, filename = "__base__/graphics/icons/iron-ore-3.png", scale = 0.5, mipmap_count = 4, tint = tint}
                },
                subgroup = "raw-resource",
                order = "e[iron-ore]-" .. name,
                inventory_move_sound = item_sounds.resource_inventory_move,
                pick_sound = item_sounds.resource_inventory_pickup,
                drop_sound = item_sounds.resource_inventory_move,
                stack_size = 50,
                weight = 2 * kg
            },
            {
                type = "recipe",
                name = CONSTANTS.mod_name .. "-" .. name .. "-smelting",
                localised_name = {"recipe-name." .. CONSTANTS.mod_name .. "-ore-smelting", {"entity-name." .. CONSTANTS.mod_name .. "-iron-" .. name}},
                category = "smelting",
                enabled = true,
                auto_recycle = false,
                energy_required = 3.2,
                ingredients = {{type = "item", name = CONSTANTS.mod_name .. "-iron-" .. name, amount = 1}},
                results = {{type="item", name="iron-plate", amount=1}},
                main_product = "iron-plate",
                allow_productivity = true
            }
        })
    end

    local pyrite_tint = {r=1, g=0.8, b=0.4}
    clone_iron(CONSTANTS.mod_name .. "-iron-pyrite", pyrite_tint, 1, 3, {
        {
            type = "item",
            name = CONSTANTS.mod_name .. "-iron-pyrite",
            amount = 1
        },
        {
            type = "item",
            name = "stone",
            amount = 1,
            probability = 0.01
        }
    })
    clone_iron_item("pyrite", pyrite_tint)

    local hematite_tint = {r=1, g=0.3, b=0.3}
    clone_iron(CONSTANTS.mod_name .. "-iron-hematite", hematite_tint, 5, 10)
    clone_iron_item("hematite", hematite_tint)

    local siderite_tint = {r=1, g=0.75, b=0.5}
    clone_iron(CONSTANTS.mod_name .. "-iron-siderite", {r=1, g=0.75, b=0.5}, 1 / 2., 1 / 3.)
    clone_iron_item("siderite", siderite_tint)

    local magnetite_tint = {r=0.8, g=0.8, b=0.9}
    clone_iron(CONSTANTS.mod_name .. "-iron-magnetite", magnetite_tint, 3, 1)
    data:extend({
        {
            type = "item",
            name = CONSTANTS.mod_name .. "-iron-magnetite",
            localised_name = {"entity-name." .. CONSTANTS.mod_name .. "-iron-magnetite"},
            icons = {
                {
                    icon = "__base__/graphics/icons/iron-ore.png",
                    tint = magnetite_tint
                }
            },
            pictures =
            {
                {size = 64, filename = "__base__/graphics/icons/iron-ore.png", scale = 0.5, mipmap_count = 4, tint = magnetite_tint},
                {size = 64, filename = "__base__/graphics/icons/iron-ore-1.png", scale = 0.5, mipmap_count = 4, tint = magnetite_tint},
                {size = 64, filename = "__base__/graphics/icons/iron-ore-2.png", scale = 0.5, mipmap_count = 4, tint = magnetite_tint},
                {size = 64, filename = "__base__/graphics/icons/iron-ore-3.png", scale = 0.5, mipmap_count = 4, tint = magnetite_tint}
            },
            subgroup = "raw-resource",
            order = "e[iron-ore]-magnetite",
            inventory_move_sound = item_sounds.resource_inventory_move,
            pick_sound = item_sounds.resource_inventory_pickup,
            drop_sound = item_sounds.resource_inventory_move,
            stack_size = 50,
            weight = 2 * kg
        },
        {
            type = "recipe",
            name = CONSTANTS.mod_name .. "-steel-from-magnetite",
            category = "smelting",
            enabled = false,
            energy_required = 32,
            ingredients = {{type = "item", name = CONSTANTS.mod_name .. "-iron-magnetite", amount = 1}},
            results = {{type="item", name="steel-plate", amount=1}},
            main_product = "steel-plate",
            allow_productivity = true
        }
    })
    if data.raw.technology["steel-processing"] then
        data.raw.technology["steel-processing"].effects = data.raw.technology["steel-processing"].effects or {}
        table.insert(data.raw.technology["steel-processing"].effects, 2, {type = "unlock-recipe", recipe = CONSTANTS.mod_name .. "-steel-from-magnetite"})
    end

    local limonite_tint = {r=0.7, g=0.5, b=0.2}
    clone_iron(CONSTANTS.mod_name .. "-iron-limonite", limonite_tint, 1.5, 1)
    clone_iron_item("limonite", limonite_tint)
    data:extend({
        {
            type = "recipe",
            name = CONSTANTS.mod_name .. "-limonite-conversion",
            category = "crafting",
            enabled = true,
            auto_recycle = false,
            energy_required = 1,
            ingredients = {{type = "item", name = CONSTANTS.mod_name .. "-iron-limonite", amount = 2}},
            results = {{type="item", name="copper-ore", amount=1}},
            main_product = "copper-ore",
            allow_productivity = true,
            allow_decomposition = false
        }
    })

    local goethite_tint = {r=0.6, g=0.5, b=0.4}
    clone_iron(CONSTANTS.mod_name .. "-iron-goethite", goethite_tint, 2, 1)
    clone_iron_item("goethite", goethite_tint)
    data.raw.resource[CONSTANTS.mod_name .. "-iron-goethite"].autoplace = resource_autoplace.resource_autoplace_settings{
        name = CONSTANTS.mod_name .. "-iron-goethite",
        order = "b",
        base_density = BASE_DENSITY * 1.,
        has_starting_area_placement = false,
        regular_rq_factor_multiplier = 1.1 * 2,
        random_spot_size_minimum = 0.25 * 2,
        random_spot_size_maximum = 2 * 2
    }

    local taconite_tint = {r=0.9, g=0.75, b=0.6}
    clone_iron(CONSTANTS.mod_name .. "-iron-taconite", taconite_tint, 1, 2, {
        {
            type = "item",
            name = CONSTANTS.mod_name .. "-iron-taconite",
            amount = 100,
            probability = 0.01
        }
    })
    clone_iron_item("taconite", taconite_tint)
end