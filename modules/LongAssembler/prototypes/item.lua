local item_sounds = require("__base__.prototypes.item_sounds")

local CONSTANTS = require("common.constants")

data:extend({
    {
        type = "item",
        name = CONSTANTS.mod_name .. "-long-assembler-2",
        icon = "__" .. CONSTANTS.mod_name .. "__/graphics/LongAssembler/long-assembler-2.png",
        subgroup = "production-machine",
        color_hint = { text = "2" },
        order = "b[assembling-machine-2]-long",
        inventory_move_sound = item_sounds.mechanical_inventory_move,
        pick_sound = item_sounds.mechanical_inventory_pickup,
        drop_sound = item_sounds.mechanical_inventory_move,
        place_result = CONSTANTS.mod_name .. "-long-assembler-2",
        stack_size = 50,
        weight = 20 * kg
    },
    {
        type = "item",
        name = CONSTANTS.mod_name .. "-long-assembler-3",
        icon = "__" .. CONSTANTS.mod_name .. "__/graphics/LongAssembler/long-assembler-3.png",
        subgroup = "production-machine",
        color_hint = { text = "3" },
        order = "c[assembling-machine-3]-long",
        inventory_move_sound = item_sounds.mechanical_inventory_move,
        pick_sound = item_sounds.mechanical_inventory_pickup,
        drop_sound = item_sounds.mechanical_inventory_move,
        place_result = CONSTANTS.mod_name .. "-long-assembler-3",
        stack_size = 50,
        weight = 20 * kg
    }
})