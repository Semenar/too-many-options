require ("util")
require ("circuit-connector-sprites")
require ("__base__.prototypes.entity.assemblerpipes")
require ("__base__.prototypes.entity.pipecovers")
require ("__base__.prototypes.entity.entity-util")
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

local CONSTANTS = require("common.constants")

data:extend({
    {
        type = "assembling-machine",
        name = CONSTANTS.mod_name .. "-long-assembler-2",
        icon = "__" .. CONSTANTS.mod_name .. "__/graphics/LongAssembler/long-assembler-2.png",
        flags = {"placeable-neutral", "placeable-player", "player-creation"},
        minable = {mining_time = 0.2, result = CONSTANTS.mod_name .. "-long-assembler-2"},
        max_health = 450,
        corpse = "assembling-machine-2-remnants",
        dying_explosion = "assembling-machine-2-explosion",
        icon_draw_specification = {shift = {0, -0.3}},
        circuit_wire_max_distance = assembling_machine_circuit_wire_max_distance,
        circuit_connector = circuit_connector_definitions["assembling-machine"],
        alert_icon_shift = util.by_pixel(0, -12),
        resistances =
        {
            {
                type = "fire",
                percent = 70
            }
        },
        fluid_boxes =
        {
            {
                production_type = "input",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                volume = 1000,
                pipe_connections = {{ flow_direction="input-output", direction = defines.direction.west, position = {-1.5, 0} }},
                secondary_draw_orders = { west = 1, east = 1 }
            },
            {
                production_type = "input",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                volume = 1000,
                pipe_connections = {{ flow_direction="input-output", direction = defines.direction.east, position = {1.5, 0} }},
                secondary_draw_orders = { east = 1, west = 1 }
            },
            {
                production_type = "output",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                volume = 1000,
                pipe_connections = {{ flow_direction="output", direction = defines.direction.north, position = {-0.5, -1} }},
                secondary_draw_orders = { north = 2, south = 2 }
            },
            {
                production_type = "output",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                volume = 1000,
                pipe_connections = {{ flow_direction="output", direction = defines.direction.north, position = {0.5, -1} }},
                secondary_draw_orders = { north = 1, south = 1 }
            },
            {
                production_type = "output",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                volume = 1000,
                pipe_connections = {{ flow_direction="output", direction = defines.direction.south, position = {-0.5, 1} }},
                secondary_draw_orders = { south = 1, north = 1 }
            },
            {
                production_type = "output",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                volume = 1000,
                pipe_connections = {{ flow_direction="output", direction = defines.direction.south, position = {0.5, 1} }},
                secondary_draw_orders = { south = 2, north = 2 }
            }
        },
        fluid_boxes_off_when_no_fluid_recipe = true,
        collision_box = {{-1.7, -1.2}, {1.7, 1.2}},
        selection_box = {{-2, -1.5}, {2, 1.5}},
        damaged_trigger_effect = hit_effects.entity(),
        fast_replaceable_group = CONSTANTS.mod_name .. "-long-assembler",
        -- next_upgrade = CONSTANTS.mod_name .. "-long-assembler-3",
        graphics_set =
        {
            animation =
            {
                north = {
                    layers =
                    {
                        {
                            filename = "__" .. CONSTANTS.mod_name .. "__/graphics/LongAssembler/long-assembler-2-horizontal.png",
                            priority = "high",
                            width = 286,
                            height = 218,
                            frame_count = 32,
                            line_length = 8,
                            shift = util.by_pixel(0, 4),
                            scale = 0.5
                        },
                        {
                            filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-shadow.png",
                            priority = "high",
                            width = 196,
                            height = 163,
                            frame_count = 32,
                            line_length = 8,
                            draw_as_shadow = true,
                            shift = util.by_pixel(28, 4.75),
                            scale = 0.5
                        }
                    }
                },
                east = {
                    layers =
                    {
                        {
                            filename = "__" .. CONSTANTS.mod_name .. "__/graphics/LongAssembler/long-assembler-2-vertical.png",
                            priority = "high",
                            width = 214,
                            height = 290,
                            frame_count = 32,
                            line_length = 8,
                            shift = util.by_pixel(0, 4),
                            scale = 0.5
                        },
                        {
                            filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-shadow.png",
                            priority = "high",
                            width = 196,
                            height = 163,
                            frame_count = 32,
                            line_length = 8,
                            draw_as_shadow = true,
                            shift = util.by_pixel(12, 20.75),
                            scale = 0.5
                        }
                    }
                },
                south = {
                    layers =
                    {
                        {
                            filename = "__" .. CONSTANTS.mod_name .. "__/graphics/LongAssembler/long-assembler-2-horizontal.png",
                            priority = "high",
                            width = 286,
                            height = 218,
                            frame_count = 32,
                            line_length = 8,
                            shift = util.by_pixel(0, 4),
                            scale = 0.5
                        },
                        {
                            filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-shadow.png",
                            priority = "high",
                            width = 196,
                            height = 163,
                            frame_count = 32,
                            line_length = 8,
                            draw_as_shadow = true,
                            shift = util.by_pixel(28, 4.75),
                            scale = 0.5
                        }
                    }
                },
                west = {
                    layers =
                    {
                        {
                            filename = "__" .. CONSTANTS.mod_name .. "__/graphics/LongAssembler/long-assembler-2-vertical.png",
                            priority = "high",
                            width = 214,
                            height = 290,
                            frame_count = 32,
                            line_length = 8,
                            shift = util.by_pixel(0, 4),
                            scale = 0.5
                        },
                        {
                            filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-shadow.png",
                            priority = "high",
                            width = 196,
                            height = 163,
                            frame_count = 32,
                            line_length = 8,
                            draw_as_shadow = true,
                            shift = util.by_pixel(12, 20.75),
                            scale = 0.5
                        }
                    }
                },
            },
        },
        open_sound = sounds.machine_open,
        close_sound = sounds.machine_close,
        impact_category = "metal",
        working_sound =
        {
            sound = {filename = "__base__/sound/assembling-machine-t2-1.ogg", volume = 0.45, audible_distance_modifier = 0.5},
            fade_in_ticks = 4,
            fade_out_ticks = 20
        },
        crafting_categories = {"basic-crafting", "crafting", "advanced-crafting", "crafting-with-fluid"},
        crafting_speed = 1,
        energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = { pollution = 4 }
        },
        energy_usage = "240kW",
        module_slots = 2,
        allowed_effects = {"consumption", "speed", "productivity", "pollution", "quality"}
    },
    {
        type = "assembling-machine",
        name = CONSTANTS.mod_name .. "-long-assembler-3",
        icon = "__" .. CONSTANTS.mod_name .. "__/graphics/LongAssembler/long-assembler-3.png",
        flags = {"placeable-neutral", "placeable-player", "player-creation"},
        minable = {mining_time = 0.2, result = CONSTANTS.mod_name .. "-long-assembler-3"},
        max_health = 500,
        corpse = "assembling-machine-3-remnants",
        dying_explosion = "assembling-machine-3-explosion",
        icon_draw_specification = {shift = {0, -0.3}},
        circuit_wire_max_distance = assembling_machine_circuit_wire_max_distance,
        circuit_connector = circuit_connector_definitions["assembling-machine"],
        alert_icon_shift = util.by_pixel(0, -12),
        resistances =
        {
            {
                type = "fire",
                percent = 70
            }
        },
        fluid_boxes =
        {
            {
                production_type = "input",
                pipe_picture = assembler3pipepictures(),
                pipe_covers = pipecoverspictures(),
                volume = 1000,
                pipe_connections = {{ flow_direction="input-output", direction = defines.direction.west, position = {-1.5, 0} }},
                secondary_draw_orders = { west = 1, east = 1 }
            },
            {
                production_type = "input",
                pipe_picture = assembler3pipepictures(),
                pipe_covers = pipecoverspictures(),
                volume = 1000,
                pipe_connections = {{ flow_direction="input-output", direction = defines.direction.east, position = {1.5, 0} }},
                secondary_draw_orders = { east = 1, west = 1 }
            },
            {
                production_type = "output",
                pipe_picture = assembler3pipepictures(),
                pipe_covers = pipecoverspictures(),
                volume = 1000,
                pipe_connections = {{ flow_direction="output", direction = defines.direction.north, position = {-0.5, -1} }},
                secondary_draw_orders = { north = 2, south = 2 }
            },
            {
                production_type = "output",
                pipe_picture = assembler3pipepictures(),
                pipe_covers = pipecoverspictures(),
                volume = 1000,
                pipe_connections = {{ flow_direction="output", direction = defines.direction.north, position = {0.5, -1} }},
                secondary_draw_orders = { north = 1, south = 1 }
            },
            {
                production_type = "output",
                pipe_picture = assembler3pipepictures(),
                pipe_covers = pipecoverspictures(),
                volume = 1000,
                pipe_connections = {{ flow_direction="output", direction = defines.direction.south, position = {-0.5, 1} }},
                secondary_draw_orders = { south = 1, north = 1 }
            },
            {
                production_type = "output",
                pipe_picture = assembler3pipepictures(),
                pipe_covers = pipecoverspictures(),
                volume = 1000,
                pipe_connections = {{ flow_direction="output", direction = defines.direction.south, position = {0.5, 1} }},
                secondary_draw_orders = { south = 2, north = 2 }
            }
        },
        fluid_boxes_off_when_no_fluid_recipe = true,
        collision_box = {{-1.7, -1.2}, {1.7, 1.2}},
        selection_box = {{-2, -1.5}, {2, 1.5}},
        damaged_trigger_effect = hit_effects.entity(),
        drawing_box_vertical_extension = 0.2,
        fast_replaceable_group = CONSTANTS.mod_name .. "-long-assembler",
        graphics_set =
        {
            animation_progress = 0.5,
            animation =
            {
                north = {
                    layers =
                    {
                        {
                            filename = "__" .. CONSTANTS.mod_name .. "__/graphics/LongAssembler/long-assembler-3-horizontal.png",
                            priority = "high",
                            width = 286,
                            height = 237,
                            frame_count = 32,
                            line_length = 8,
                            shift = util.by_pixel(0, -0.75),
                            scale = 0.5
                        },
                        {
                            filename = "__base__/graphics/entity/assembling-machine-3/assembling-machine-3-shadow.png",
                            priority = "high",
                            width = 260,
                            height = 162,
                            frame_count = 32,
                            line_length = 8,
                            draw_as_shadow = true,
                            shift = util.by_pixel(44, 4),
                            scale = 0.5
                        }
                    }
                },
                east = {
                    layers =
                    {
                        {
                            filename = "__" .. CONSTANTS.mod_name .. "__/graphics/LongAssembler/long-assembler-3-vertical.png",
                            priority = "high",
                            width = 214,
                            height = 316,
                            frame_count = 32,
                            line_length = 8,
                            shift = util.by_pixel(0, -1),
                            scale = 0.5
                        },
                        {
                            filename = "__base__/graphics/entity/assembling-machine-3/assembling-machine-3-shadow.png",
                            priority = "high",
                            width = 260,
                            height = 162,
                            frame_count = 32,
                            line_length = 8,
                            draw_as_shadow = true,
                            shift = util.by_pixel(28, 20),
                            scale = 0.5
                        }
                    }
                },
                south = {
                    layers =
                    {
                        {
                            filename = "__" .. CONSTANTS.mod_name .. "__/graphics/LongAssembler/long-assembler-3-horizontal.png",
                            priority = "high",
                            width = 286,
                            height = 237,
                            frame_count = 32,
                            line_length = 8,
                            shift = util.by_pixel(0, -0.75),
                            scale = 0.5
                        },
                        {
                            filename = "__base__/graphics/entity/assembling-machine-3/assembling-machine-3-shadow.png",
                            priority = "high",
                            width = 260,
                            height = 162,
                            frame_count = 32,
                            line_length = 8,
                            draw_as_shadow = true,
                            shift = util.by_pixel(44, 4),
                            scale = 0.5
                        }
                    }
                },
                west = {
                    layers =
                    {
                        {
                            filename = "__" .. CONSTANTS.mod_name .. "__/graphics/LongAssembler/long-assembler-3-vertical.png",
                            priority = "high",
                            width = 214,
                            height = 316,
                            frame_count = 32,
                            line_length = 8,
                            shift = util.by_pixel(0, -1),
                            scale = 0.5
                        },
                        {
                            filename = "__base__/graphics/entity/assembling-machine-3/assembling-machine-3-shadow.png",
                            priority = "high",
                            width = 260,
                            height = 162,
                            frame_count = 32,
                            line_length = 8,
                            draw_as_shadow = true,
                            shift = util.by_pixel(28, 20),
                            scale = 0.5
                        }
                    }
                },
            },
        },
        open_sound = sounds.machine_open,
        close_sound = sounds.machine_close,
        impact_category = "metal",
        working_sound =
        {
            sound = {filename = "__base__/sound/assembling-machine-t3-1.ogg", volume = 0.45, audible_distance_modifier = 0.5},
            fade_in_ticks = 4,
            fade_out_ticks = 20
        },
        crafting_categories = {"basic-crafting", "crafting", "advanced-crafting", "crafting-with-fluid"},
        crafting_speed = 1.6,
        energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = { pollution = 2.5 }
        },
        energy_usage = "500kW",
        module_slots = 4,
        allowed_effects = {"consumption", "speed", "productivity", "pollution", "quality"}
    }
})

if data.raw["assembling-machine"]["assembling-machine-2"] then
    data.raw["assembling-machine"][CONSTANTS.mod_name .. "-long-assembler-2"].heating_energy = data.raw["assembling-machine"]["assembling-machine-2"].heating_energy
end
if data.raw["assembling-machine"]["assembling-machine-3"] then
    data.raw["assembling-machine"][CONSTANTS.mod_name .. "-long-assembler-3"].heating_energy = data.raw["assembling-machine"]["assembling-machine-3"].heating_energy
end