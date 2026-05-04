local CONSTANTS = require("common.constants")

local lib_recipe = require("lib.recipe")

data:extend({
    {
        type = "recipe",
        name = CONSTANTS.mod_name .. "-long-assembler-2",
        enabled = false,
        ingredients = lib_recipe.ingredients_sum(data.raw.recipe["assembling-machine-2"] and data.raw.recipe["assembling-machine-2"].ingredients, {
            {type = "item", name = "steel-plate", amount = 2},
            {type = "item", name = "iron-gear-wheel", amount = 4}
        }),
        results = {{type="item", name=CONSTANTS.mod_name .. "-long-assembler-2", amount=1}}
    },
    {
        type = "recipe",
        name = CONSTANTS.mod_name .. "-long-assembler-3",
        enabled = false,
        ingredients = lib_recipe.ingredients_sum(data.raw.recipe["assembling-machine-3"] and data.raw.recipe["assembling-machine-3"].ingredients, {
            {type = "item", name = "assembling-machine-2", amount = -2},
            {type = "item", name=CONSTANTS.mod_name .. "-long-assembler-2", amount = 2}
        }),
        results = {{type="item", name=CONSTANTS.mod_name .. "-long-assembler-3", amount=1}}
    }
})

if data.raw.technology["automation-2"] then
    data.raw.technology["automation-2"].effects = data.raw.technology["automation-2"].effects or {}
    table.insert(data.raw.technology["automation-2"].effects, {type = "unlock-recipe", recipe = CONSTANTS.mod_name .. "-long-assembler-2"})
end

if data.raw.technology["automation-3"] then
    data.raw.technology["automation-3"].effects = data.raw.technology["automation-3"].effects or {}
    table.insert(data.raw.technology["automation-3"].effects, {type = "unlock-recipe", recipe = CONSTANTS.mod_name .. "-long-assembler-3"})
end