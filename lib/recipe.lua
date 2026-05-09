local lib = {}

---@param type string
---@param amt double
---@return double
lib.apply_ingredient_count_limits = function(type, amt)
    if type == "item" and amt > 65535 then amt = 65535 end -- 2^16 - 1
    if type == "fluid" and amt > 549755813887 then amt = 549755813887 end -- 2^39 - 1

    return amt
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
---@param multiplier double
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
---@param multiplier_dict {[string]: double}
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
---@param old_item string
---@param new_item? string
---@param new_amount? number
lib.replace_item_ingredient = function(recipe, old_item, new_item, new_amount)
    if new_item ~= nil then
        for _, ingredient in ipairs(recipe.ingredients) do
            if ingredient.name == old_item then
                ingredient.name = new_item
                if new_amount ~= nil then
                    ingredient.amount = new_amount
                end
            end
        end
    else
        local new_ingredients = {}
        for _, ingredient in ipairs(recipe.ingredients) do
            if ingredient.name ~= old_item then
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
            if result.name == old_item then
                result.name = new_item
                if new_amount ~= nil then
                    result.amount = new_amount
                end
            end
        end
    else
        local new_results = {}
        for _, result in ipairs(recipe.results) do
            if result.name ~= old_item then
                table.insert(new_results, result)
            end
        end
        recipe.results = new_results
    end
end

return lib