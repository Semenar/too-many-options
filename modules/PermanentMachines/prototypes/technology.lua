local CONSTANTS = require("common.constants")

data:extend({
    {
        type = "technology",
        name = CONSTANTS.mod_name .. "-unlock-permanent-machines-1",
        icons = {
            {
                icon = "__core__/graphics/empty.png",
                icon_size = 64,
                scale = 2
            },
            {
                icon = "__base__/graphics/technology/automation-2.png",
                icon_size = 256,
                scale = 0.5 * 0.6,
                shift = {32 * (1 - 0.6) / 0.6, 0},
                draw_background = true
            },
            {
                icon = "__base__/graphics/technology/steel-axe.png",
                icon_size = 256,
                scale = 0.5 * 0.6,
                shift = {-32 * (1 - 0.6) / 0.6, 0},
                draw_background = true
            }
        },
        unit = {
            count = 10,
            time = 15,
            ingredients = {
                {"automation-science-pack", 1}
            }
        },
        prerequisites = {"concrete"}
    },
    {
        type = "technology",
        name = CONSTANTS.mod_name .. "-unlock-permanent-machines-2",
        icons = {
            {
                icon = "__core__/graphics/empty.png",
                icon_size = 64,
                scale = 2
            },
            {
                icon = "__base__/graphics/technology/automation-2.png",
                icon_size = 256,
                scale = 0.5 * 0.6,
                shift = {32 * (1 - 0.6) / 0.6, 0},
                draw_background = true
            },
            {
                icon = "__base__/graphics/technology/steel-axe.png",
                icon_size = 256,
                scale = 0.5 * 0.6,
                shift = {-32 * (1 - 0.6) / 0.6, 0},
                draw_background = true
            }
        },
        max_level = "infinite",
        unit = {
            count_formula = "25*L",
            time = 30,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 1}
            }
        },
        prerequisites = {CONSTANTS.mod_name .. "-unlock-permanent-machines-1", "production-science-pack"}
    }
})