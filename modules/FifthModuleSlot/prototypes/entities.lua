local CONSTANTS = require("common.constants")

require("util")

local lib_energy = require("lib.energy")

local machine_spec = {
    original_name = "assembling-machine-3",
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
            filename = "__reskins-assets-base__/graphics/entity/assembling-machine/animations/assembling-machine-animation-5.png",
            priority = "high",
            width = 214,
            height = 237,
            scale = 0.5,
            shift = util.by_pixel(0, -0.75),
            frame_count = 32,
            line_length = 8
        },
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
            icon = "__reskins-assets-base__/graphics/icons/assembling-machine/gear-3.png",
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
}

---@param name string
---@param tint Color
---@return data.AssemblingMachinePrototype | nil
local function copy_assembler(name, tint)
    if not data.raw["assembling-machine"][machine_spec.original_name] then return nil end
    local machine = table.deepcopy(data.raw["assembling-machine"][machine_spec.original_name])

    machine.name = CONSTANTS.mod_name .. "-" .. name
    machine.minable = machine.minable or {mining_time = 0.2}
    -- machine.minable.result = machine.name
    machine.minable.results = nil
    machine.minable.count = nil
    machine.next_upgrade = nil
    machine.icon = nil
    machine.icons = {}
    if machine_spec.icon_base_layers then
        for _, icon in ipairs(machine_spec.icon_base_layers) do
            local icon_layer = table.deepcopy(icon)
            table.insert(machine.icons, icon_layer)
        end
    end
    if machine_spec.icon_tint_layers then
        for _, icon in ipairs(machine_spec.icon_tint_layers) do
            local icon_layer = table.deepcopy(icon)
            icon_layer.tint = table.deepcopy(tint)
            table.insert(machine.icons, icon_layer)
        end
    end
    if machine_spec.icon_after_tint_layers then
        for _, icon in ipairs(machine_spec.icon_after_tint_layers) do
            local icon_layer = table.deepcopy(icon)
            table.insert(machine.icons, icon_layer)
        end
    end
    machine.graphics_set = machine.graphics_set or {}
    machine.graphics_set.animation = {layers = {}}
    if machine_spec.base_layers then
        for _, animation in ipairs(machine_spec.base_layers) do
            local animation_layer = table.deepcopy(animation)
            table.insert(machine.graphics_set.animation.layers, animation_layer)
        end
    end
    if machine_spec.tint_layers then
        for _, animation in ipairs(machine_spec.tint_layers) do
            local animation_layer = table.deepcopy(animation)
            animation_layer.tint = table.deepcopy(tint)
            table.insert(machine.graphics_set.animation.layers, animation_layer)
        end
    end
    if machine_spec.after_tint_layers then
        for _, animation in ipairs(machine_spec.after_tint_layers) do
            local animation_layer = table.deepcopy(animation)
            table.insert(machine.graphics_set.animation.layers, animation_layer)
        end
    end

    machine.graphics_set_flipped = nil
    if machine_spec.pipe_layers or machine_spec.pipe_tint_layers or machine_spec.pipe_after_tint_layers then
        if machine.fluid_boxes then
            for _, fluidbox in ipairs(machine.fluid_boxes) do
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
                            pic_layer.tint = table.deepcopy(tint)
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

    machine.module_slots = (machine.module_slots or 0) + 1
    return machine
end

local OVERCLOCKED_MACHINE_TINT = {r = 1, g = 0.3, b = 0.3}
local OVERCLOCKED_MACHINE_POWER_MULTIPLIER = 10
local OVERCLOCKED_MACHINE_SPEED_MULTIPLIER = 0.6

local OFFSHORE_MACHINE_TINT = {r = 0.3, g = 0.3, b = 1}

local FALLOUT_MACHINE_TINT = {r = 0.3, g = 1, b = 0.3}

local overclocked_machine = copy_assembler("overclocked-machine", OVERCLOCKED_MACHINE_TINT)
if overclocked_machine then
    overclocked_machine.energy_usage = lib_energy.convert_to_energy(util.parse_energy(overclocked_machine.energy_usage) * OVERCLOCKED_MACHINE_POWER_MULTIPLIER)
    overclocked_machine.crafting_speed = overclocked_machine.crafting_speed * OVERCLOCKED_MACHINE_SPEED_MULTIPLIER
    data:extend({overclocked_machine})
end

local offshore_machine = copy_assembler("offshore-machine", OFFSHORE_MACHINE_TINT)
if offshore_machine then
    offshore_machine.collision_mask = {layers = {meltable = true, object = true, is_object = true, is_lower_object = true}}
    offshore_machine.tile_buildability_rules = {
        {area = {{-1.4, -1.4}, {1.4, 1.4}}, required_tiles = {layers={water_tile=true}}}
    }
    offshore_machine.fast_replaceable_group = nil
    data:extend({offshore_machine})
end

local fallout_machine = copy_assembler("fallout-machine", FALLOUT_MACHINE_TINT)
if fallout_machine and data.raw.tile["nuclear-ground"] then
    data:extend({
        { type = "collision-layer", order = "nuke", name = "nuclear_ground" }
    })
    data.raw.tile["nuclear-ground"].collision_mask = data.raw.tile["nuclear-ground"].collision_mask or {}
    data.raw.tile["nuclear-ground"].collision_mask.layers = data.raw.tile["nuclear-ground"].collision_mask.layers or {ground_tile = true}
    data.raw.tile["nuclear-ground"].collision_mask.layers.nuclear_ground = true

    fallout_machine.fast_replaceable_group = nil
    fallout_machine.tile_buildability_rules = {
        {area = {{-1.4, -1.4}, {1.4, 1.4}}, required_tiles = {layers={nuclear_ground=true}}}
    }

    data:extend({fallout_machine})
end