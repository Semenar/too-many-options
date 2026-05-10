require("util")

local PERMANENT_MACHINE_TINT = {r = 0.4, g = 0.4, b = 0.4}

local CONSTANTS = require("common.constants")

local lib_prototypes = require("lib.prototypes")
local lib_vectors = require("lib.vectors")

local PERMANENT_MACHINE_HEALTH_MULT = 10
local PERMANENT_MACHINE_PRODUCTIVITY_BONUS_PERCENT = 25

local PERMANENT_MACHINES = {
    {
        original_name = "assembling-machine-2",
        tint = lib_vectors.color_mult(PERMANENT_MACHINE_TINT, {r = 0.42, g = 0.65, b = 0.95}),
        base_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/assembling-machine/assembling-machine-base.png",
                priority = "high",
                width = 214,
                height = 237,
                scale = 0.5,
                shift = util.by_pixel(0, -0.75),
                frame_count = 1,
                repeat_count = 32
            },
            {
                filename = "__reskins-assets-base__/graphics/entity/assembling-machine/shadows/assembling-machine-2-shadow.png",
                priority = "high",
                draw_as_shadow = true,
                width = 264,
                height = 165,
                scale = 0.5,
                shift = util.by_pixel(28, 4),
                frame_count = 32,
                line_length = 8
            }
        },
        tint_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/assembling-machine/assembling-machine-base-mask.png",
                priority = "high",
                width = 214,
                height = 237,
                scale = 0.5,
                shift = util.by_pixel(0, -0.75),
                frame_count = 1,
                repeat_count = 32
            }
        },
        after_tint_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/assembling-machine/assembling-machine-base-highlights.png",
                priority = "high",
                width = 214,
                height = 237,
                scale = 0.5,
                shift = util.by_pixel(0, -0.75),
                frame_count = 1,
                repeat_count = 32
            },
            {
                filename = "__reskins-assets-base__/graphics/entity/assembling-machine/animations/assembling-machine-animation-2.png",
                priority = "high",
                width = 214,
                height = 237,
                scale = 0.5,
                shift = util.by_pixel(0, -0.75),
                frame_count = 32,
                line_length = 8
            }
        },
        icon_base_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/assembling-machine/assembling-machine-icon-base.png",
                icon_size = 64
            }
        },
        icon_tint_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/assembling-machine/assembling-machine-icon-mask.png",
                icon_size = 64
            }
        },
        icon_after_tint_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/assembling-machine/assembling-machine-icon-highlights.png",
                icon_size = 64
            },
            {
                icon = "__reskins-assets-base__/graphics/icons/assembling-machine/gear-1.png",
                icon_size = 64
            }
        },
        pipe_layers = {
            north = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-north-base.png",
                    priority = "high",
                    width = 71,
                    height = 38,
                    shift = util.by_pixel(2.25, 13.5),
                    scale = 0.5
                }
            },
            east = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-east-base.png",
                    priority = "high",
                    width = 42,
                    height = 76,
                    shift = util.by_pixel(-24.5, 1),
                    scale = 0.5
                }
            },
            south = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-south-base.png",
                    priority = "high",
                    width = 88,
                    height = 61,
                    shift = util.by_pixel(0, -31.25),
                    scale = 0.5
                }
            },
            west = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-west-base.png",
                    priority = "high",
                    width = 39,
                    height = 73,
                    shift = util.by_pixel(25.75, 1.25),
                    scale = 0.5
                }
            }
        },
        pipe_tint_layers = {
            north = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-north-mask.png",
                    priority = "high",
                    width = 71,
                    height = 38,
                    shift = util.by_pixel(2.25, 13.5),
                    scale = 0.5
                }
            },
            east = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-east-mask.png",
                    priority = "high",
                    width = 42,
                    height = 76,
                    shift = util.by_pixel(-24.5, 1),
                    scale = 0.5
                }
            },
            south = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-south-mask.png",
                    priority = "high",
                    width = 88,
                    height = 61,
                    shift = util.by_pixel(0, -31.25),
                    scale = 0.5
                }
            },
            west = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-west-mask.png",
                    priority = "high",
                    width = 39,
                    height = 73,
                    shift = util.by_pixel(25.75, 1.25),
                    scale = 0.5
                }
            }
        },
        pipe_after_tint_layers = {
            north = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-north-highlights.png",
                    priority = "high",
                    width = 71,
                    height = 38,
                    shift = util.by_pixel(2.25, 13.5),
                    scale = 0.5
                }
            },
            east = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-east-highlights.png",
                    priority = "high",
                    width = 42,
                    height = 76,
                    shift = util.by_pixel(-24.5, 1),
                    scale = 0.5
                }
            },
            south = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-south-highlights.png",
                    priority = "high",
                    width = 88,
                    height = 61,
                    shift = util.by_pixel(0, -31.25),
                    scale = 0.5
                }
            },
            west = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-west-highlights.png",
                    priority = "high",
                    width = 39,
                    height = 73,
                    shift = util.by_pixel(25.75, 1.25),
                    scale = 0.5
                }
            }
        }
    },
    {
        original_name = "assembling-machine-3",
        tint = lib_vectors.color_mult(PERMANENT_MACHINE_TINT, {r = 0.55, g = 0.65, b = 0.3}),
        base_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/assembling-machine/assembling-machine-base.png",
                priority = "high",
                width = 214,
                height = 237,
                scale = 0.5,
                shift = util.by_pixel(0, -0.75),
                frame_count = 1,
                repeat_count = 32
            },
            {
                filename = "__reskins-assets-base__/graphics/entity/assembling-machine/shadows/assembling-machine-4-shadow.png",
                priority = "high",
                draw_as_shadow = true,
                width = 264,
                height = 165,
                scale = 0.5,
                shift = util.by_pixel(28, 4),
                frame_count = 32,
                line_length = 8
            }
        },
        tint_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/assembling-machine/assembling-machine-base-mask.png",
                priority = "high",
                width = 214,
                height = 237,
                scale = 0.5,
                shift = util.by_pixel(0, -0.75),
                frame_count = 1,
                repeat_count = 32
            }
        },
        after_tint_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/assembling-machine/assembling-machine-base-highlights.png",
                priority = "high",
                width = 214,
                height = 237,
                scale = 0.5,
                shift = util.by_pixel(0, -0.75),
                frame_count = 1,
                repeat_count = 32
            },
            {
                filename = "__reskins-assets-base__/graphics/entity/assembling-machine/animations/assembling-machine-animation-4.png",
                priority = "high",
                width = 214,
                height = 237,
                scale = 0.5,
                shift = util.by_pixel(0, -0.75),
                frame_count = 32,
                line_length = 8
            }
        },
        icon_base_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/assembling-machine/assembling-machine-icon-base.png",
                icon_size = 64
            }
        },
        icon_tint_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/assembling-machine/assembling-machine-icon-mask.png",
                icon_size = 64
            }
        },
        icon_after_tint_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/assembling-machine/assembling-machine-icon-highlights.png",
                icon_size = 64
            },
            {
                icon = "__reskins-assets-base__/graphics/icons/assembling-machine/gear-2.png",
                icon_size = 64
            }
        },
        pipe_layers = {
            north = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-north-base.png",
                    priority = "high",
                    width = 71,
                    height = 38,
                    shift = util.by_pixel(2.25, 13.5),
                    scale = 0.5
                }
            },
            east = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-east-base.png",
                    priority = "high",
                    width = 42,
                    height = 76,
                    shift = util.by_pixel(-24.5, 1),
                    scale = 0.5
                }
            },
            south = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-south-base.png",
                    priority = "high",
                    width = 88,
                    height = 61,
                    shift = util.by_pixel(0, -31.25),
                    scale = 0.5
                }
            },
            west = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-west-base.png",
                    priority = "high",
                    width = 39,
                    height = 73,
                    shift = util.by_pixel(25.75, 1.25),
                    scale = 0.5
                }
            }
        },
        pipe_tint_layers = {
            north = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-north-mask.png",
                    priority = "high",
                    width = 71,
                    height = 38,
                    shift = util.by_pixel(2.25, 13.5),
                    scale = 0.5
                }
            },
            east = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-east-mask.png",
                    priority = "high",
                    width = 42,
                    height = 76,
                    shift = util.by_pixel(-24.5, 1),
                    scale = 0.5
                }
            },
            south = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-south-mask.png",
                    priority = "high",
                    width = 88,
                    height = 61,
                    shift = util.by_pixel(0, -31.25),
                    scale = 0.5
                }
            },
            west = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-west-mask.png",
                    priority = "high",
                    width = 39,
                    height = 73,
                    shift = util.by_pixel(25.75, 1.25),
                    scale = 0.5
                }
            }
        },
        pipe_after_tint_layers = {
            north = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-north-highlights.png",
                    priority = "high",
                    width = 71,
                    height = 38,
                    shift = util.by_pixel(2.25, 13.5),
                    scale = 0.5
                }
            },
            east = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-east-highlights.png",
                    priority = "high",
                    width = 42,
                    height = 76,
                    shift = util.by_pixel(-24.5, 1),
                    scale = 0.5
                }
            },
            south = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-south-highlights.png",
                    priority = "high",
                    width = 88,
                    height = 61,
                    shift = util.by_pixel(0, -31.25),
                    scale = 0.5
                }
            },
            west = {
                {
                    filename = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/assembling-machine-pipe-west-highlights.png",
                    priority = "high",
                    width = 39,
                    height = 73,
                    shift = util.by_pixel(25.75, 1.25),
                    scale = 0.5
                }
            }
        }
    },
    {
        original_name = "chemical-plant",
        tint = PERMANENT_MACHINE_TINT,
        make_4way = true,
        base_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/chemical-plant/chemical-plant-base.png",
                width = 220,
                height = 292,
                frame_count = 24,
                line_length = 12,
                shift = util.by_pixel(0.5, -9),
                scale = 0.5
            },
            {
                filename = "__base__/graphics/entity/chemical-plant/chemical-plant-shadow.png",
                width = 312,
                height = 222,
                repeat_count = 24,
                shift = util.by_pixel(27, 6),
                draw_as_shadow = true,
                scale = 0.5
            }
        },
        tint_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/chemical-plant/chemical-plant-mask.png",
                width = 220,
                height = 292,
                frame_count = 24,
                line_length = 12,
                shift = util.by_pixel(0.5, -9),
                scale = 0.5
            }
        },
        after_tint_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/chemical-plant/chemical-plant-highlights.png",
                width = 220,
                height = 292,
                frame_count = 24,
                line_length = 12,
                shift = util.by_pixel(0.5, -9),
                scale = 0.5
            }
        },
        icon_base_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/chemical-plant/chemical-plant-icon-base.png",
                icon_size = 64
            }
        },
        icon_tint_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/chemical-plant/chemical-plant-icon-mask.png",
                icon_size = 64
            }
        },
        icon_after_tint_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/chemical-plant/chemical-plant-icon-highlights.png",
                icon_size = 64
            }
        }
    },
    {
        original_name = "steel-furnace",
        tint = PERMANENT_MACHINE_TINT,
        base_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/furnace-steel/furnace-steel-base.png",
                priority = "high",
                width = 172,
                height = 174,
                shift = util.by_pixel(-1.25, 2),
                scale = 0.5
            },
            {
                filename = "__reskins-assets-base__/graphics/entity/furnace-steel/shadows/furnace-steel-shadow.png",
                priority = "high",
                width = 282,
                height = 142,
                draw_as_shadow = true,
                shift = util.by_pixel(39.25, 5),
                scale = 0.5
            }
        },
        tint_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/furnace-steel/furnace-steel-mask.png",
                priority = "high",
                width = 172,
                height = 174,
                shift = util.by_pixel(-1.25, 2),
                scale = 0.5
            }
        },
        after_tint_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/furnace-steel/furnace-steel-highlights.png",
                priority = "high",
                width = 172,
                height = 174,
                shift = util.by_pixel(-1.25, 2),
                scale = 0.5
            }
        },
        icon_base_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/furnace-steel/furnace-steel-icon-base.png",
                icon_size = 64
            }
        },
        icon_tint_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/furnace-steel/furnace-steel-icon-mask.png",
                icon_size = 64
            }
        },
        icon_after_tint_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/furnace-steel/furnace-steel-icon-highlights.png",
                icon_size = 64
            }
        }
    },
    {
        original_name = "electric-furnace",
        tint = PERMANENT_MACHINE_TINT,
        base_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/furnace-electric/furnace-electric-base.png",
                priority = "high",
                width = 238,
                height = 212,
                scale = 0.5
            },
            {
                filename = "__reskins-assets-base__/graphics/entity/furnace-electric/shadows/furnace-electric-shadow.png",
                priority = "high",
                width = 228,
                height = 172,
                draw_as_shadow = true,
                shift = util.by_pixel(11.25, 7.75),
                scale = 0.5
            }
        },
        tint_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/furnace-electric/furnace-electric-mask.png",
                priority = "high",
                width = 238,
                height = 212,
                scale = 0.5
            }
        },
        after_tint_layers = {
            {
                filename = "__reskins-assets-base__/graphics/entity/furnace-electric/furnace-electric-highlights.png",
                priority = "high",
                width = 238,
                height = 212,
                scale = 0.5
            }
        },
        icon_base_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/furnace-electric/furnace-electric-icon-base.png",
                icon_size = 64
            }
        },
        icon_tint_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/furnace-electric/furnace-electric-icon-mask.png",
                icon_size = 64
            }
        },
        icon_after_tint_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/furnace-electric/furnace-electric-icon-highlights.png",
                icon_size = 64
            }
        }
    },
    {
        original_name = "boiler",
        tint = PERMANENT_MACHINE_TINT,
        icon_base_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/boiler/boiler-icon-base.png",
                icon_size = 64
            }
        },
        icon_tint_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/boiler/boiler-icon-mask.png",
                icon_size = 64
            }
        },
        icon_after_tint_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/boiler/boiler-icon-highlights.png",
                icon_size = 64
            }
        }
    },
    {
        original_name = "steam-engine",
        tint = PERMANENT_MACHINE_TINT,
        icon_base_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/steam-engine/steam-engine-icon-base.png",
                icon_size = 64
            }
        },
        icon_tint_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/steam-engine/steam-engine-icon-mask.png",
                icon_size = 64
            }
        },
        icon_after_tint_layers = {
            {
                icon = "__reskins-assets-base__/graphics/icons/steam-engine/steam-engine-icon-highlights.png",
                icon_size = 64
            }
        }
    }
}

for _, machine_spec in ipairs(PERMANENT_MACHINES) do
    ---@type data.EntityWithHealthPrototype | nil
    local original_machine = lib_prototypes.get_named_prototype("entity", machine_spec.original_name)

    if original_machine ~= nil then
        ---@type data.EntityWithHealthPrototype
        local permanent_machine = table.deepcopy(original_machine)

        permanent_machine.name = CONSTANTS.mod_name .. "-" .. machine_spec.original_name .. "-permanent"
        permanent_machine.localised_name = {
            "entity-name." .. CONSTANTS.mod_name .. "-permanent-machine",
            original_machine.localised_name or {"entity-name." .. machine_spec.original_name}
        }
        permanent_machine.localised_description = {"entity-description." .. CONSTANTS.mod_name .. "-permanent-machine"}
        permanent_machine.minable = nil
        permanent_machine.fast_replaceable_group =
            CONSTANTS.mod_name .. "-" .. machine_spec.original_name .. "-permanent"
        permanent_machine.next_upgrade = nil
        permanent_machine.icon = nil
        permanent_machine.flags = permanent_machine.flags or {}
        table.insert(permanent_machine.flags, "not-deconstructable")
        permanent_machine.icons = {}
        if machine_spec.icon_base_layers then
            for _, icon in ipairs(machine_spec.icon_base_layers) do
                local icon_layer = table.deepcopy(icon)
                table.insert(permanent_machine.icons, icon_layer)
            end
        end
        if machine_spec.icon_tint_layers then
            for _, icon in ipairs(machine_spec.icon_tint_layers) do
                local icon_layer = table.deepcopy(icon)
                icon_layer.tint = table.deepcopy(machine_spec.tint)
                table.insert(permanent_machine.icons, icon_layer)
            end
        end
        if machine_spec.icon_after_tint_layers then
            for _, icon in ipairs(machine_spec.icon_after_tint_layers) do
                local icon_layer = table.deepcopy(icon)
                table.insert(permanent_machine.icons, icon_layer)
            end
        end
        table.insert(
            permanent_machine.icons,
            {
                icon = "__core__/graphics/icons/technology/effect-constant/effect-constant-productivity.png",
                icon_size = 64
            }
        )
        permanent_machine.graphics_set = permanent_machine.graphics_set or {}
        permanent_machine.graphics_set.animation = {layers = {}}
        if machine_spec.base_layers then
            for _, animation in ipairs(machine_spec.base_layers) do
                local animation_layer = table.deepcopy(animation)
                table.insert(permanent_machine.graphics_set.animation.layers, animation_layer)
            end
        end
        if machine_spec.tint_layers then
            for _, animation in ipairs(machine_spec.tint_layers) do
                local animation_layer = table.deepcopy(animation)
                animation_layer.tint = table.deepcopy(machine_spec.tint)
                table.insert(permanent_machine.graphics_set.animation.layers, animation_layer)
            end
        end
        if machine_spec.after_tint_layers then
            for _, animation in ipairs(machine_spec.after_tint_layers) do
                local animation_layer = table.deepcopy(animation)
                table.insert(permanent_machine.graphics_set.animation.layers, animation_layer)
            end
        end
        if machine_spec.make_4way == true then
            permanent_machine.graphics_set.animation =
                make_4way_animation_from_spritesheet(permanent_machine.graphics_set.animation)
        end
        permanent_machine.graphics_set_flipped = nil
        if machine_spec.pipe_layers or machine_spec.pipe_tint_layers or machine_spec.pipe_after_tint_layers then
            if permanent_machine.fluid_boxes then
                for _, fluidbox in ipairs(permanent_machine.fluid_boxes) do
                    fluidbox.pipe_picture = {
                        north = {layers = {}},
                        east = {layers = {}},
                        south = {layers = {}},
                        west = {layers = {}}
                    }
                    if machine_spec.pipe_layers then
                        for direction, pics in pairs(machine_spec.pipe_layers) do
                            for _, pic in ipairs(pics) do
                                local pic_layer = table.deepcopy(pic)
                                table.insert(fluidbox.pipe_picture[direction].layers, pic_layer)
                            end
                        end
                    end
                    if machine_spec.pipe_tint_layers then
                        for direction, pics in pairs(machine_spec.pipe_tint_layers) do
                            for _, pic in ipairs(pics) do
                                local pic_layer = table.deepcopy(pic)
                                pic_layer.tint = table.deepcopy(machine_spec.tint)
                                table.insert(fluidbox.pipe_picture[direction].layers, pic_layer)
                            end
                        end
                    end
                    if machine_spec.pipe_after_tint_layers then
                        for direction, pics in pairs(machine_spec.pipe_after_tint_layers) do
                            for _, pic in ipairs(pics) do
                                local pic_layer = table.deepcopy(pic)
                                table.insert(fluidbox.pipe_picture[direction].layers, pic_layer)
                            end
                        end
                    end
                end
            end
        end
        permanent_machine.max_health = (permanent_machine.max_health or 10) * PERMANENT_MACHINE_HEALTH_MULT
        permanent_machine.effect_receiver = permanent_machine.effect_receiver or {}
        permanent_machine.effect_receiver.base_effect = {
            productivity = PERMANENT_MACHINE_PRODUCTIVITY_BONUS_PERCENT / 100.
        }

        if permanent_machine.energy_source then
            permanent_machine.energy_source.effectivity = 1 + PERMANENT_MACHINE_PRODUCTIVITY_BONUS_PERCENT / 100.
        end
        if machine_spec.original_name == "boiler" then
            permanent_machine.energy_consumption =
                tostring(
                (1 + PERMANENT_MACHINE_PRODUCTIVITY_BONUS_PERCENT / 100.) * 60 *
                    util.parse_energy(permanent_machine.energy_consumption)
            ) .. "W"
        end
        if machine_spec.original_name == "steam-engine" then
            permanent_machine.effectivity = 1 + PERMANENT_MACHINE_PRODUCTIVITY_BONUS_PERCENT / 100.
        end

        ---@type data.EntityWithHealthPrototype
        local unlocked_machine = table.deepcopy(permanent_machine)
        unlocked_machine.name = unlocked_machine.name .. "-unlocked"
        unlocked_machine.localised_description = nil
        unlocked_machine.hidden_in_factoriopedia = true
        unlocked_machine.minable = {
            mining_time = 1,
            result = permanent_machine.name
        }
        unlocked_machine.flags = table.deepcopy(original_machine.flags or {})
        table.insert(unlocked_machine.flags, "not-in-made-in")
        unlocked_machine.max_health = original_machine.max_health
        unlocked_machine.placeable_by = {item = permanent_machine.name, count = 1}

        ---@type data.ItemPrototype
        local machine_item =
            table.deepcopy(
            lib_prototypes.get_named_prototype("item", machine_spec.original_name) or
                {
                    type = "item",
                    order = CONSTANTS.mod_name .. "-" .. machine_spec.original_name,
                    stack_size = 50,
                    weight = 20 * kg
                }
        )
        machine_item.name = permanent_machine.name
        machine_item.place_result = machine_item.name
        machine_item.icon = nil
        machine_item.icons = table.deepcopy(permanent_machine.icons)
        machine_item.order = machine_item.order .. "-u[permanent]"

        local foundation_item = "refined-concrete"
        if machine_spec.original_name == "boiler" or machine_spec.original_name == "steam-engine" then
            foundation_item = "stone-brick"
        end

        ---@type data.RecipePrototype
        local machine_recipe = {
            type = "recipe",
            name = permanent_machine.name,
            ingredients = {
                {type = "item", name = machine_spec.original_name, amount = 1},
                {
                    type = "item",
                    name =  foundation_item,
                    amount = lib_vectors.bounding_box_area(original_machine.selection_box)
                }
            },
            results = {
                {type = "item", name = machine_item.name, amount = 1, ignored_by_productivity = 1}
            },
            auto_recycle = false,
            allow_productivity = false
        }

        for _, technology in pairs(data.raw.technology) do
            if technology.effects then
                local has_original_recipe_unlock = false
                for _, effect in ipairs(technology.effects) do
                    if effect.type == "unlock-recipe" and effect.recipe == machine_spec.original_name then
                        has_original_recipe_unlock = true
                    end
                end
                if has_original_recipe_unlock then
                    machine_recipe.enabled = false
                    table.insert(technology.effects, {type = "unlock-recipe", recipe = machine_recipe.name})
                end
            end
        end

        data:extend({permanent_machine, unlocked_machine, machine_item, machine_recipe})
    end
end
