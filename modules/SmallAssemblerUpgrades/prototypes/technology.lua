local CONSTANTS = require("common.constants")

data:extend({
    {
        type = "technology",
        name = "faster-small-assemblers",
        icon = data.raw.item[CONSTANTS.mod_name .. "-small-assembler-1"].icon,
        icon_size = data.raw.item[CONSTANTS.mod_name .. "-small-assembler-1"].icon_size or 64,
        upgrade = true,
        max_level = 98,
        prerequisites = {
            "automation"
        },
        unit = {
            count_formula = "25*L^2",
            time = 10,
            ingredients = {
                {"automation-science-pack", 1},
            },
        },
        effects = {}
    }
})