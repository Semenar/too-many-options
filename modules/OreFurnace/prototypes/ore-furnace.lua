require("util")

local CONSTANTS = require("common.constants")

local lib_prototypes = require("lib.prototypes")
local lib_recipe = require("lib.recipe")
local lib_vectors = require("lib.vectors")

local lib_cache = require("lib.cache")
lib_cache.invalidate_cache()

local machine_spec = {
    original_name = "stone-furnace",
    tint = {r = 1, g = 0.5, b = 0.25},
    base_layers = {
        {
            filename = "__reskins-assets-base__/graphics/entity/furnace-stone/furnace-stone-base.png",
            priority = "extra-high",
            width = 152,
            height = 152,
            scale = 0.5
        },
        {
            filename = "__reskins-assets-base__/graphics/entity/furnace-stone/shadows/furnace-stone-shadow.png",
            priority = "extra-high",
            width = 176,
            height = 140,
            draw_as_shadow = true,
            shift = util.by_pixel(12, 0),
            scale = 0.5
        }
    },
    tint_layers = {
        {
            filename = "__reskins-assets-base__/graphics/entity/furnace-stone/furnace-stone-mask.png",
            priority = "extra-high",
            width = 152,
            height = 152,
            scale = 0.5
        }
    },
    after_tint_layers = {
        {
            filename = "__reskins-assets-base__/graphics/entity/furnace-stone/furnace-stone-highlights.png",
            priority = "extra-high",
            width = 152,
            height = 152,
            scale = 0.5
        }
    },
    icon_base_layers = {
        {
            icon = "__reskins-assets-base__/graphics/icons/furnace-stone/furnace-stone-icon-base.png",
            icon_size = 64
        }
    },
    icon_tint_layers = {
        {
            icon = "__reskins-assets-base__/graphics/icons/furnace-stone/furnace-stone-icon-mask.png",
            icon_size = 64
        }
    },
    icon_after_tint_layers = {
        {
            icon = "__reskins-assets-base__/graphics/icons/furnace-stone/furnace-stone-icon-highlights.png",
            icon_size = 64
        }
    }
}

local ORE_FURNACE_PRODUCTIVITY_BONUS_PERCENT = 50

---@param tint Color
---@return data.Animation
local function make_animation(machine_spec, tint)
    local ret = {layers = {}}
    if machine_spec.base_layers then
        for _, animation in ipairs(machine_spec.base_layers) do
            local animation_layer = table.deepcopy(animation)
            table.insert(ret.layers, animation_layer)
        end
    end
    if machine_spec.tint_layers then
        for _, animation  in ipairs(machine_spec.tint_layers) do
            local animation_layer = table.deepcopy(animation)
            animation_layer.tint = table.deepcopy(tint)
            table.insert(ret.layers, animation_layer)
        end
    end
    if machine_spec.after_tint_layers then
        for _, animation  in ipairs(machine_spec.after_tint_layers) do
            local animation_layer = table.deepcopy(animation)
            table.insert(ret.layers, animation_layer)
        end
    end
    return ret
end

---@param tint Color
---@return data.IconData
local function make_icon(machine_spec, tint)
    local ret = {}
    if machine_spec.icon_base_layers then
        for _, icon in ipairs(machine_spec.icon_base_layers) do
            local icon_layer = table.deepcopy(icon)
            table.insert(ret, icon_layer)
        end
    end
    if machine_spec.icon_tint_layers then
        for _, icon in ipairs(machine_spec.icon_tint_layers) do
            local icon_layer = table.deepcopy(icon)
            icon_layer.tint = table.deepcopy(tint)
            table.insert(ret, icon_layer)
        end
    end
    if machine_spec.icon_after_tint_layers then
        for _, icon in ipairs(machine_spec.icon_after_tint_layers) do
            local icon_layer = table.deepcopy(icon)
            table.insert(ret, icon_layer)
        end
    end
    return ret
end

local original_machine = lib_prototypes.get_named_prototype("entity", machine_spec.original_name)
if original_machine ~= nil then
    ---@type data.FurnacePrototype
    local machine = table.deepcopy(original_machine)
    machine.name = CONSTANTS.mod_name .. "-ore-furnace"
    machine.localised_description = {"entity-description." .. machine.name, tostring(ORE_FURNACE_PRODUCTIVITY_BONUS_PERCENT)}
    machine.minable = machine.minable or {mining_time = 0.2}
    machine.minable.results = nil
    machine.minable.result = machine.name
    machine.minable.count = nil
    machine.graphics_set = machine.graphics_set or {}
    machine.graphics_set.animation = make_animation(machine_spec, machine_spec.tint)
    machine.graphics_set_flipped = nil
    machine.icons = make_icon(machine_spec, machine_spec.tint)
    machine.icon = nil
    machine.icon_size = nil
    machine.fast_replaceable_group = CONSTANTS.mod_name .. "-ore-furnace"
    machine.next_upgrade = nil

    -- Check which ores satisfy the requirements to be included
    ---@type data.ResourceEntityPrototype[]
    local valid_resources = {}

    ---@type {[string]: string[]}
    local valid_resource_ores = {}

    ---@type {[string]: string}
    local smelting_recipe = {}

    if data.raw.resource then
        for _, resource in pairs(data.raw.resource) do
            local is_valid = true
            local resource_ores = {}

            -- Must be minable
            if not resource.minable then
                is_valid = false
            else
                -- Must not require a fluid to mine
                if resource.minable.required_fluid then
                    is_valid = false
                end
            end

            -- Must allow placing a building on top
            if resource.collision_mask and resource.collision_mask.layers and resource.collision_mask.layers.object ~= nil then
                is_valid = false
            end

            -- Check all mining outputs now
            local mining_outputs = {}
            if resource.minable then
                if resource.minable.results then
                    for _, result in ipairs(resource.minable.results) do
                        if result.type ~= "fluid" and lib_recipe.product_amount(result) > 0.199 then -- Only permit ores with >= 0.2 probability of appearing
                            table.insert(mining_outputs, result.name)
                        end
                    end
                else
                    table.insert(mining_outputs, resource.minable.result)
                end
            end

            -- Check each mining output whether it has a smelting recipe
            if is_valid then
                for _, ore in ipairs(mining_outputs) do
                    for _, recipe in ipairs(lib_cache.ingredient_to_recipe()["item." .. ore]) do
                        if recipe.category == "smelting" and table_size(recipe.ingredients) == 1 then
                            smelting_recipe[ore] = recipe.name
                            table.insert(resource_ores, ore)
                            break
                        end
                    end
                end
            end

            if table_size(resource_ores) == 0 then
                is_valid = false
            end

            if is_valid then
                table.insert(valid_resources, resource)
                valid_resource_ores[resource.name] = resource_ores
            end
        end
    end

    ---@type data.ItemPrototype
    local machine_item = table.deepcopy(lib_prototypes.get_named_prototype("item", machine_spec.original_name) or {
        type = "item",
        order = CONSTANTS.mod_name .. "-ore-furnace",
        stack_size = 50,
        weight = 20 * kg
    })
    machine_item.name = machine.name
    machine_item.localised_name = {"entity-name." .. machine.name}
    machine_item.place_result = machine_item.name
    machine_item.icon = nil
    machine_item.icons = table.deepcopy(machine.icons)
    machine_item.order = machine_item.order .. "-u[ore]"

    if table_size(valid_resources) > 0 then
        data:extend({machine, machine_item})

        -- Make a furnace for each resource
        for _, resource in ipairs(valid_resources) do
            local specific_machine = table.deepcopy(machine)
            specific_machine.name = CONSTANTS.mod_name .. "-ore-furnace-specific-" .. resource.name
            if resource.localised_name then
                specific_machine.localised_name = {"entity-name." .. CONSTANTS.mod_name .. "-ore-furnace-specific", table.deepcopy(resource.localised_name)}
                specific_machine.localised_description = {"entity-description." .. CONSTANTS.mod_name .. "-ore-furnace-specific", table.deepcopy(resource.localised_name)}
            else
                specific_machine.localised_name = {"entity-name." .. CONSTANTS.mod_name .. "-ore-furnace-specific", {"entity-name." .. resource.name}}
                specific_machine.localised_description = {"entity-description." .. CONSTANTS.mod_name .. "-ore-furnace-specific", {"entity-name." .. resource.name}}
            end

            specific_machine.effect_receiver = specific_machine.effect_receiver or {}
            specific_machine.effect_receiver.base_effect = {productivity = ORE_FURNACE_PRODUCTIVITY_BONUS_PERCENT / 100.}

            ---@type Color
            local tint = lib_vectors.normalize_color(resource.map_color)
            tint.a = 1
            specific_machine.graphics_set.animation = make_animation(machine_spec, tint)
            specific_machine.icons = make_icon(machine_spec, tint)
            specific_machine.deconstruction_alternative = machine.name
            specific_machine.placeable_by = {item = machine.name, count = 1}
            specific_machine.hidden_in_factoriopedia = true

            specific_machine.crafting_categories = {specific_machine.name}

            for _, ore in ipairs(valid_resource_ores[resource.name]) do
                local recipe = smelting_recipe[ore]
                if recipe and data.raw.recipe[recipe] then
                    data.raw.recipe[recipe].additional_categories = data.raw.recipe[recipe].additional_categories or {}
                    table.insert(data.raw.recipe[recipe].additional_categories, specific_machine.name)
                end
            end

            local recipe_category = {
                type = "recipe-category",
                name = specific_machine.name
            }

            data:extend({specific_machine, recipe_category})
        end

        -- Create the furnace recipe: 1 of each ore involved

        ---@type (data.FluidIngredientPrototype | data.ItemIngredientPrototype)[]
        local recipe_ingredients = {}
        for ore, _ in pairs(smelting_recipe) do
            table.insert(recipe_ingredients, {type = "item", name = ore, amount = 1})
        end

        data:extend({
            {
                type = "recipe",
                name = machine.name,
                category = "crafting",
                energy_required = 5,
                ingredients = recipe_ingredients,
                results = {{type = "item", name = machine.name, amount = 1}},
                auto_recycle = false,
                allow_productivity = false,
            }
        })
    end
end