local CONSTANTS = require("common.constants")

--for i = 1, 40 do
    --[[local prerequisites = {
        "fluid-handling"
    }
    if i > 1 then
        table.insert(prerequisites, "hotter-steam-" .. tostring(i - 1))
    end]]
    data:extend({
        {
            type = "technology",
            name = "hotter-steam",
            icon = data.raw.fluid.steam.icon,
            icon_size = data.raw.fluid.steam.icon_size or 64,
            upgrade = true,
            max_level = 40,
            prerequisites = {
                "fluid-handling"
            },
            unit = {
                --count = 100 * math.pow(2, i - 1),
                count_formula = "100*2^(L-1)",
                time = 15,
                ingredients = {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                },
            },
            effects = {
                {
                    type = "nothing",
                    hidden = true,
                    effect_description = {CONSTANTS.mod_name .. "-disable-with", "oil-processing"}
                }
            }
        }
    })
--end