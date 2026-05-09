local CONSTANTS = require("common.constants")

local lib_cache = require("lib.cache")
lib_cache.invalidate_cache()

local lib_recipe = require("lib.recipe")
local lib_graphics = require("lib.graphics")
local lib_technologies = require("lib.technologies")

---@param recipes data.RecipePrototype[] | nil
---@return string[] | nil
local function recipes_to_names(recipes)
    if recipes == nil then return nil end
    local ret = {}
    for _, recipe in ipairs(recipes) do
        table.insert(ret, recipe.name)
    end
    return ret
end

---@param technology data.TechnologyPrototype
---@return number
--- A crude estimation of when this technology would normally unlock in the progression
local function technology_cost(technology)
    if not technology then return CONSTANTS.Infinity end
    if technology.research_trigger then
        if not technology.prerequisites then return 10 end
        local max_cost = 10
        for _, prereq in ipairs(technology.prerequisites) do
            max_cost = math.max(max_cost, technology_cost(data.raw.technology[prereq]))
        end
        return max_cost
    end

    if not technology.unit then return CONSTANTS.Infinity end
    local price = technology.unit.count
    if technology.unit.count_formula then
        local technology_level = lib_technologies.get_technology_level(technology)
        price = helpers.evaluate_expression(technology.unit.count_formula, { L = technology_level, l = technology_level })
    end
    local unit_count = 0
    if technology.unit.ingredients then
        for _, ingredient in ipairs(technology.unit.ingredients) do
            unit_count = unit_count + ingredient[2]
        end
    end
    return price * unit_count
end

---@param recipes string[] | nil
---@param name string
---@param ingredients string[]
---@param base_cost number
---@param end_tech string
---@param research_time number
---@param cost_scaling? number
local function create_conditional_productivity_technology(recipes, name, ingredients, base_cost, end_tech, research_time, cost_scaling)
    if recipes == nil then return end

    local verified_recipes = {}
    for _, recipe in ipairs(recipes) do
        if data.raw.recipe[recipe] then
            table.insert(verified_recipes, recipe)
        end
    end

    if table_size(verified_recipes) == 0 then return end
    if not data.raw.technology[end_tech] then return end

    if research_time == nil then research_time = 60 end
    if cost_scaling == nil then cost_scaling = 1.5 end

    local cheapest_unlock_tech = nil
    local enabled_from_start = false
    for _, recipe in ipairs(verified_recipes) do
        if data.raw.recipe[recipe].enabled == false then
            local unlock_techs = lib_cache.recipe_to_technology_unlock()[recipe]
            if unlock_techs ~= nil then
                for _, technology in ipairs(unlock_techs) do
                    if cheapest_unlock_tech == nil then
                        cheapest_unlock_tech = technology
                    else
                        if technology_cost(technology) < technology_cost(cheapest_unlock_tech) then
                            cheapest_unlock_tech = technology
                        end
                    end
                end
            end
        else
            enabled_from_start = true
        end
    end

    if cheapest_unlock_tech == nil and not enabled_from_start then
        return -- no way to unlock recipe
    end

    local technology_icon = lib_graphics.get_rescaled_icon(lib_recipe.get_recipe_icon(data.raw.recipe[verified_recipes[1]]), 0.8, 256, true)
    table.insert(technology_icon, {
        icon = "__core__/graphics/icons/technology/effect-constant/effect-constant-recipe-productivity.png",
        icon_size = 64,
        scale = 1,
        shift = {32, 32}
    })
    local technology_ingredients = {}
    for _, ingredient in ipairs(ingredients) do
        table.insert(technology_ingredients, {ingredient, 1})
    end
    local technology_prerequisites = {}
    if cheapest_unlock_tech ~= nil then
        technology_prerequisites = {cheapest_unlock_tech.name}
    end
    for _, pack in ipairs(ingredients) do
        if data.raw.technology[pack] then
            table.insert(technology_prerequisites, pack)
        end
    end
    local technology_effects = {}
    for _, recipe in ipairs(verified_recipes) do
        table.insert(technology_effects, {
            type = "change-recipe-productivity",
            recipe = recipe,
            change = 0.1
        })
    end
    table.insert(technology_effects, {
        type = "nothing",
        hidden = true,
        effect_description = {CONSTANTS.mod_name .. "-disable-with", end_tech}
    })

    data:extend({
        {
            type = "technology",
            name = CONSTANTS.mod_name .. "-" .. name .. "-until-" .. end_tech .. "-productivity-1",
            localised_name = {"technology-name." .. CONSTANTS.mod_name .. "-conditional-productivity", lib_recipe.get_localised_name(data.raw.recipe[verified_recipes[1]])},
            localised_description = {"technology-description." .. CONSTANTS.mod_name .. "-conditional-productivity", lib_technologies.get_localised_name(data.raw.technology[end_tech])},
            icons = technology_icon,
            unit = {
                count_formula = base_cost .. "*" .. cost_scaling .. "^(L-1)",
                ingredients = technology_ingredients,
                time = research_time
            },
            max_level = "infinite",
            prerequisites = technology_prerequisites,
            effects = technology_effects
        }
    })
end

create_conditional_productivity_technology(recipes_to_names(lib_cache.product_to_recipe()["item.iron-plate"]), "iron-plate", {"automation-science-pack"}, 100, "automation", 30)

