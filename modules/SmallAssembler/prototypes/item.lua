local CONSTANTS = require("common.constants")

local item_sounds = require("__base__.prototypes.item_sounds")

for i=1,3 do
    local order_letter = "a"
    if i == 2 then order_letter = "b" end
    if i == 3 then order_letter = "c" end
    data:extend({
        {
            type = "item",
            name = CONSTANTS.mod_name .. "-small-assembler-" .. i,
            icon = "__" .. CONSTANTS.mod_name .. "__/graphics/SmallAssembler/small-assembler-" .. i .. ".png",
            subgroup = "production-machine",
            color_hint = { text = "" .. i },
            order = order_letter .. "[assembling-machine-" .. i .. "]-small",
            inventory_move_sound = item_sounds.mechanical_inventory_move,
            pick_sound = item_sounds.mechanical_inventory_pickup,
            drop_sound = item_sounds.mechanical_inventory_move,
            place_result = CONSTANTS.mod_name .. "-small-assembler-" .. i,
            stack_size = 50,
            weight = 20 * kg
        }
    })
end