local CONSTANTS = require("common.constants")

local lib_recipe = require("lib.recipe")

for i=1,3 do
    if data.raw.recipe["assembling-machine-" .. i] then
        data:extend({
            {
                type = "recipe",
                name = CONSTANTS.mod_name .. "-small-assembler-" .. i,
                enabled = false,
                ingredients = lib_recipe.ingredients_mult(data.raw.recipe["assembling-machine-" .. i].ingredients, 0.6),
                results = {{type="item", name=CONSTANTS.mod_name .. "-small-assembler-" .. i, amount=1}}
            }
        })
        lib_recipe.replace_item_ingredient(data.raw.recipe[CONSTANTS.mod_name .. "-small-assembler-" .. i], "assembling-machine-" .. (i-1), CONSTANTS.mod_name .. "-small-assembler-" .. (i-1))
    end
end

if data.raw.technology["automation"] and data.raw.recipe[CONSTANTS.mod_name .. "-small-assembler-1"] then
    data.raw.technology["automation"].effects = data.raw.technology["automation"].effects or {}
    table.insert(data.raw.technology["automation"].effects, 2, {type = "unlock-recipe", recipe = CONSTANTS.mod_name .. "-small-assembler-1"})
end

if data.raw.technology["automation-2"] and data.raw.recipe[CONSTANTS.mod_name .. "-small-assembler-2"] then
    data.raw.technology["automation-2"].effects = data.raw.technology["automation-2"].effects or {}
    table.insert(data.raw.technology["automation-2"].effects, {type = "unlock-recipe", recipe = CONSTANTS.mod_name .. "-small-assembler-2"})
end

if data.raw.technology["automation-3"] and data.raw.recipe[CONSTANTS.mod_name .. "-small-assembler-3"] then
    data.raw.technology["automation-3"].effects = data.raw.technology["automation-3"].effects or {}
    table.insert(data.raw.technology["automation-3"].effects, {type = "unlock-recipe", recipe = CONSTANTS.mod_name .. "-small-assembler-3"})
end