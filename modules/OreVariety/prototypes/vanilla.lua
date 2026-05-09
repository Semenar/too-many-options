local resource_autoplace = require("resource-autoplace")

-- Reduce iron and copper ore frequency 6x due to the new existing varieties
if data.raw.resource["iron-ore"] then
    data.raw.resource["iron-ore"].autoplace = resource_autoplace.resource_autoplace_settings
    {
        name = "iron-ore",
        order = "b",
        base_density = 10 / 6.,
        base_spots_per_km = nil,
        has_starting_area_placement = true,
        regular_rq_factor_multiplier = 1.1,
        starting_rq_factor_multiplier = 1.5,
        candidate_spot_count = 22,
        tile_restriction = nil
    }
end

if data.raw.resource["copper-ore"] then
    data.raw.resource["copper-ore"].autoplace = resource_autoplace.resource_autoplace_settings
    {
        name = "copper-ore",
        order = "b",
        base_density = 8 / 6.,
        base_spots_per_km = nil,
        has_starting_area_placement = true,
        regular_rq_factor_multiplier = 1.1,
        starting_rq_factor_multiplier = 1.2,
        candidate_spot_count = 22,
        tile_restriction = nil
    }
end