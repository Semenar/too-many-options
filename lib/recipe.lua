local lib = {}

local util = require("util")
local lib_prototypes = require("lib.prototypes")

---@param type string
---@param amt number
---@return number
lib.apply_ingredient_count_limits = function(type, amt)
    if type == "item" and amt > 65535 then amt = 65535 end -- 2^16 - 1
    if type == "fluid" and amt > 549755813887 then amt = 549755813887 end -- 2^39 - 1

    return amt
end

---@param product data.FluidProductPrototype | data.ItemProductPrototype
---@return number
lib.product_amount = function(product)
    local probability = product.probability
    if probability == nil then probability = 1 end

    if product.amount then return probability * product.amount
    else return probability * (product.amount_min + math.max(product.amount_max, product.amount_min)) / 2. end
end

---@param a [data.IngredientPrototype] | nil
---@param b [data.IngredientPrototype] | nil
---@return [data.IngredientPrototype]
lib.ingredients_sum = function(a, b)
    a = a or {}
    b = b or {}

    local ingredient_count = {
        ["item"] = {},
        ["fluid"] = {}
    }

    for _, ingredient in ipairs(a) do
        ingredient_count[ingredient.type][ingredient.name] = (ingredient_count[ingredient.type][ingredient.name] or 0) + ingredient.amount
    end
    for _, ingredient in ipairs(b) do
        ingredient_count[ingredient.type][ingredient.name] = (ingredient_count[ingredient.type][ingredient.name] or 0) + ingredient.amount
    end

    ---@type [data.IngredientPrototype]
    local ret = {}

    for _, type in ipairs({"item", "fluid"}) do
        for item, amt in pairs(ingredient_count[type]) do
            if amt > 0 then
                table.insert(ret, {type = type, name = item, amount = lib.apply_ingredient_count_limits(type, amt)})
            end
        end
    end

    return ret
end

---@param ingredients [data.IngredientPrototype] | nil
---@param multiplier number
---@param round_up? boolean
---@return [data.IngredientPrototype]
lib.ingredients_mult = function(ingredients, multiplier, round_up)
    ingredients = ingredients or {}
    if round_up == nil then
        round_up = true
    end

    ---@type [data.IngredientPrototype]
    local ret = {}

    for _, ingredient in ipairs(ingredients) do
        local amt = ingredient.amount * multiplier
        if round_up then
            amt = math.ceil(amt)
        else
            amt = math.floor(amt + 0.5)
        end

        if amt > 0 then
            table.insert(ret, {type = ingredient.type, name = ingredient.name, amount = lib.apply_ingredient_count_limits(ingredient.type, amt)})
        end
    end

    return ret
end

---@param ingredients [data.IngredientPrototype] | nil
---@param multiplier_dict {[string]: number}
---@param round_up? boolean
---@return [data.IngredientPrototype]
lib.ingredients_mult_specific = function(ingredients, multiplier_dict, round_up)
    ingredients = ingredients or {}
    if round_up == nil then
        round_up = true
    end

    ---@type [data.IngredientPrototype]
    local ret = {}

    for _, ingredient in ipairs(ingredients) do
        local amt = ingredient.amount
        if multiplier_dict[ingredient.type .. "." .. ingredient.name] ~= nil then
            amt = amt * multiplier_dict[ingredient.type .. "." .. ingredient.name]
        end

        if round_up then
            amt = math.ceil(amt)
        else
            amt = math.floor(amt + 0.5)
        end

        if amt > 0 then
            table.insert(ret, {type = ingredient.type, name = ingredient.name, amount = lib.apply_ingredient_count_limits(ingredient.type, amt)})
        end
    end

    return ret
end

---@param recipe data.RecipePrototype
---@param old_item string -- Either [name] or [type].[name].
---@param new_item? string
---@param new_amount? number
lib.replace_item_ingredient = function(recipe, old_item, new_item, new_amount)
    if new_item ~= nil then
        for _, ingredient in ipairs(recipe.ingredients) do
            if ingredient.name == old_item or ingredient.type .. "." .. ingredient.name == old_item then
                ingredient.name = new_item
                if new_amount ~= nil then
                    ingredient.amount = new_amount
                end
            end
        end
    else
        local new_ingredients = {}
        for _, ingredient in ipairs(recipe.ingredients) do
            if ingredient.name ~= old_item and ingredient.type .. "." .. ingredient.name ~= old_item then
                table.insert(new_ingredients, ingredient)
            end
        end
        recipe.ingredients = new_ingredients
    end
end

---@param recipe data.RecipePrototype
---@param old_item string
---@param new_item? string
---@param new_amount? number
lib.replace_item_result = function(recipe, old_item, new_item, new_amount)
    if not recipe.results then return end
    if new_item ~= nil then
        for _, result in ipairs(recipe.results) do
            if result.name == old_item or result.type .. "." .. result.name == old_item then
                result.name = new_item
                if new_amount ~= nil then
                    result.amount = new_amount
                end
            end
        end
    else
        local new_results = {}
        for _, result in ipairs(recipe.results) do
            if result.name ~= old_item and result.type .. "." .. result.name ~= old_item then
                table.insert(new_results, result)
            end
        end
        recipe.results = new_results
    end
end

---@param recipe data.RecipePrototype
---@return data.IconData[]
lib.get_recipe_icon = function(recipe)
    if recipe.icons then return table.deepcopy(recipe.icons) or {} end
    if recipe.icon then return {{
        icon = recipe.icon,
        icon_size = recipe.icon_size or 64
    }} end
    if recipe.main_product then
        ---@type data.ItemPrototype
        local item = lib_prototypes.get_named_prototype("item", recipe.main_product)
        if item ~= nil then
            if item.icons then return table.deepcopy(item.icons) or {} end
            if item.icon then return {{
                icon = item.icon,
                icon_size = item.icon_size or 64
            }} end
        end
    end
    if recipe.results and table_size(recipe.results) == 1 then
        ---@type data.ItemPrototype | data.FluidPrototype
        local item = lib_prototypes.get_named_prototype(recipe.results[1].type, recipe.results[1].name)
        if item ~= nil then
            if item.icons then return table.deepcopy(item.icons) or {} end
            if item.icon then return {{
                icon = item.icon,
                icon_size = item.icon_size or 64
            }} end
        end
    end
    return {}
end

---@param recipe data.RecipePrototype
---@param include_count? boolean
---@return LocalisedString
lib.get_localised_name = function(recipe, include_count)
    if include_count == nil then include_count = true end

    if recipe.localised_name then return table.deepcopy(recipe.localised_name) or "" end
    if not recipe.results then return {"recipe-name." .. recipe.name} end

    local main_product = util.get_recipe_main_product(recipe, util.normalize_recipe_products(recipe))
    if main_product ~= nil then
        local main_product_prototype = lib_prototypes.get_named_prototype(main_product.type, main_product.name)
        local product_amount = lib.product_amount(main_product)
        if product_amount ~= 1 and include_count then
            if main_product_prototype ~= nil and main_product_prototype.localised_name then
                return {"?", {"recipe-name." .. recipe.name}, {"description.creates-number-entities-value", tostring(product_amount), table.deepcopy(main_product_prototype.localised_name)}}
            end
            return {"?", {"recipe-name." .. recipe.name}, {"description.creates-number-entities-value", tostring(product_amount), {main_product.type .. "-name." .. main_product.name}}}
        else
            if main_product_prototype ~= nil and main_product_prototype.localised_name then
                return {"?", {"recipe-name." .. recipe.name}, table.deepcopy(main_product_prototype.localised_name)}
            end
            return {"?", {"recipe-name." .. recipe.name}, {main_product.type .. "-name." .. main_product.name}}
        end
    end
    
    return {"recipe-name." .. recipe.name}
end

return lib