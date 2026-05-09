local lib = {}

local util = require("util")

local cache = {}

lib.invalidate_cache = function()
    cache = {}
end

---@return {[string]: data.TechnologyPrototype[]}
lib.recipe_to_technology_unlock = function()
    if cache.recipe_to_technology_unlock then return cache.recipe_to_technology_unlock end
    cache.recipe_to_technology_unlock = {}
    if data.raw.technology then
        for _, technology in pairs(data.raw.technology) do
            if technology.effects then
                for _, effect in ipairs(technology.effects) do
                    if effect.type == "unlock-recipe" then
                        cache.recipe_to_technology_unlock[effect.recipe] = cache.recipe_to_technology_unlock[effect.recipe] or {}
                        table.insert(cache.recipe_to_technology_unlock[effect.recipe], technology)
                    end
                end
            end
        end
    end
    return cache.recipe_to_technology_unlock
end

---@return {[string]: data.RecipePrototype[]}
lib.product_to_recipe = function()
    if cache.product_to_recipe then return cache.product_to_recipe end
    cache.product_to_recipe = {}
    if data.raw.recipe then
        for _, recipe in pairs(data.raw.recipe) do
            if recipe.results then
                local main_product = util.get_recipe_main_product(recipe, util.normalize_recipe_products(recipe))
                if main_product ~= nil then
                    cache.product_to_recipe[main_product.type .. "." .. main_product.name] = cache.product_to_recipe[main_product.type .. "." .. main_product.name] or {}
                    table.insert(cache.product_to_recipe[main_product.type .. "." .. main_product.name], recipe)
                end
            end
        end
    end
    return cache.product_to_recipe
end

return lib