local CONSTANTS = require("common.constants")

local lib_prototypes = require("lib.prototypes")

local lib_cache = require("lib.cache")
lib_cache.invalidate_cache()

if lib_prototypes.get_named_prototype("entity", CONSTANTS.mod_name .. "-fallout-machine") then
    local machine_name = "fallout-machine"
    data:extend({
        {
            type = "recipe",
            name = CONSTANTS.mod_name .. "-" .. machine_name,
            localised_name = {"entity-name." .. CONSTANTS.mod_name .. "-" .. machine_name},
            enabled = false,
            ingredients = {
                {type = "item", name = "uranium-235", amount = 5},
                {type = "item", name = "assembling-machine-3", amount = 1}
            },
            results = {{type = "item", name = CONSTANTS.mod_name .. "-" .. machine_name, amount = 1}}
        }
    })
    for _, technology in ipairs(lib_cache.recipe_to_technology_unlock()["assembling-machine-3"] or {}) do
        technology.effects = technology.effects or {}
        table.insert(technology.effects, {type = "unlock-recipe", recipe = CONSTANTS.mod_name .. "-" .. machine_name})
    end
end

if lib_prototypes.get_named_prototype("entity", CONSTANTS.mod_name .. "-offshore-machine") then
    local machine_name = "offshore-machine"
    data:extend({
        {
            type = "recipe",
            name = CONSTANTS.mod_name .. "-" .. machine_name,
            localised_name = {"entity-name." .. CONSTANTS.mod_name .. "-" .. machine_name},
            enabled = false,
            ingredients = {
                {type = "item", name = "offshore-pump", amount = 4},
                {type = "item", name = "refined-concrete", amount = 9},
                {type = "item", name = "assembling-machine-3", amount = 1}
            },
            results = {{type = "item", name = CONSTANTS.mod_name .. "-" .. machine_name, amount = 1}}
        }
    })
    for _, technology in ipairs(lib_cache.recipe_to_technology_unlock()["assembling-machine-3"] or {}) do
        technology.effects = technology.effects or {}
        table.insert(technology.effects, {type = "unlock-recipe", recipe = CONSTANTS.mod_name .. "-" .. machine_name})
    end
end

if lib_prototypes.get_named_prototype("entity", CONSTANTS.mod_name .. "-overclocked-machine") then
    local machine_name = "overclocked-machine"
    data:extend({
        {
            type = "recipe",
            name = CONSTANTS.mod_name .. "-" .. machine_name,
            localised_name = {"entity-name." .. CONSTANTS.mod_name .. "-" .. machine_name},
            enabled = false,
            ingredients = {
                {type = "item", name = "speed-module-2", amount = 4},
                {type = "item", name = "assembling-machine-3", amount = 1}
            },
            results = {{type = "item", name = CONSTANTS.mod_name .. "-" .. machine_name, amount = 1}}
        }
    })
    for _, technology in ipairs(lib_cache.recipe_to_technology_unlock()["assembling-machine-3"] or {}) do
        technology.effects = technology.effects or {}
        table.insert(technology.effects, {type = "unlock-recipe", recipe = CONSTANTS.mod_name .. "-" .. machine_name})
    end
end