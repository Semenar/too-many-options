local CONSTANTS = require("common.constants")

if data.raw["item-subgroup"] and not data.raw["item-subgroup"][CONSTANTS.mod_name .. "-ores"] then
    data:extend({
        {
            type = "item-subgroup",
            name = CONSTANTS.mod_name .. "-ores",
            group = "environment",
            order = "batman"
        }
    })
end