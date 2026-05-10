local CONSTANTS = require("common.constants")

local lib_prototypes = require("lib.prototypes")
local lib_recipe = require("lib.recipe")

---@type data.AssemblingMachinePrototype | nil
local offshore_machine = lib_prototypes.get_named_prototype("entity", CONSTANTS.mod_name .. "-offshore-machine")

if offshore_machine then
    data:extend({{
        type = "recipe-category",
        name = offshore_machine.name
    }})

    local allowed_recipe_categories = {}
    if offshore_machine.crafting_categories then
        for _, category in ipairs(offshore_machine.crafting_categories) do
            allowed_recipe_categories[category] = true
        end
    end
    offshore_machine.crafting_categories = {offshore_machine.name}

    if data.raw.recipe then
        for _, recipe in pairs(data.raw.recipe) do
            local has_water = false
            local has_matching_category = false
            if recipe.ingredients then
                for _, ingredient in ipairs(recipe.ingredients) do
                    if ingredient.type == "fluid" and ingredient.name == "water" then
                        has_water = true
                    end
                end
            end
            if (recipe.category or "crafting") and allowed_recipe_categories[(recipe.category or "crafting")] then has_matching_category = true end
            if recipe.additional_categories then
                for _, category in ipairs(recipe.additional_categories) do
                    if allowed_recipe_categories[category] then has_matching_category = true end
                end
            end

            if has_matching_category then
                if has_water then
                    local recipe_copy = table.deepcopy(recipe)
                    recipe_copy.name = CONSTANTS.mod_name .. "-" .. recipe_copy.name .. "-offshore"
                    lib_recipe.replace_item_ingredient(recipe_copy, "fluid.water")
                    recipe_copy.localised_name = lib_recipe.get_localised_name(recipe, false)
                    recipe_copy.category = offshore_machine.name
                    recipe_copy.additional_categories = nil
                    data:extend({recipe_copy})
                else
                    recipe.additional_categories = recipe.additional_categories or {}
                    table.insert(recipe.additional_categories, offshore_machine.name)
                end
            end
        end
    end
end