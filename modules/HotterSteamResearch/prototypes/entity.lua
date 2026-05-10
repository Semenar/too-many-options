local CONSTANTS = require("common.constants")

for i = 0, 40 do
    local boiler = table.deepcopy(data.raw.boiler.boiler)
    local steam_engine = table.deepcopy(data.raw.generator["steam-engine"])

    boiler.name = "boiler-hotter-" .. tostring(i)
    boiler.hidden = true
    boiler.hidden_in_factoriopedia = true
    boiler.localised_name = {"entity-name.boiler"}
    boiler.localised_description = {"entity-description.boiler"}
    boiler.target_temperature = boiler.target_temperature + 35 * i
    local factor_difference = (boiler.target_temperature - 15) / (165 - 15)
    boiler.energy_source.effectivity = factor_difference * boiler.energy_source.effectivity
    boiler.energy_consumption = tostring(factor_difference * 60 * util.parse_energy(boiler.energy_consumption)) .. "W"
    boiler.placeable_by = {item = "boiler", count = 1}
    steam_engine.name = "steam-engine-hotter-" .. tostring(i)
    steam_engine.hidden = true
    steam_engine.hidden_in_factoriopedia = true
    steam_engine.localised_name = {"entity-name.steam-engine"}
    steam_engine.localised_description = {"entity-description.steam_engine"}
    steam_engine.maximum_temperature = steam_engine.maximum_temperature + 35 * i
    steam_engine.placeable_by = {item = "steam-engine", count = 1}
    data:extend(
        {
            boiler,
            steam_engine
        }
    )
end

for i = 0, 40 do
    local boiler = table.deepcopy(data.raw.boiler[CONSTANTS.mod_name .. "-boiler-permanent"])
    local steam_engine = table.deepcopy(data.raw.generator[CONSTANTS.mod_name .. "-steam-engine-permanent"])

    boiler.name = "boiler-permanent-hotter-" .. tostring(i)
    boiler.hidden = true
    boiler.hidden_in_factoriopedia = true
    --boiler.localised_name = {"entity-name.boiler"}
    --boiler.localised_description = {"entity-description.boiler"}
    boiler.target_temperature = boiler.target_temperature + 35 * i
    local factor_difference = (boiler.target_temperature - 15) / (165 - 15)
    boiler.energy_source.effectivity = factor_difference * boiler.energy_source.effectivity
    boiler.energy_consumption = tostring(factor_difference * 60 * util.parse_energy(boiler.energy_consumption)) .. "W"
    boiler.placeable_by = {item = CONSTANTS.mod_name .. "-boiler-permanent", count = 1}
    steam_engine.name = "steam-engine-permanent-hotter-" .. tostring(i)
    steam_engine.hidden = true
    steam_engine.hidden_in_factoriopedia = true
    --steam_engine.localised_name = {"entity-name.steam-engine"}
    --steam_engine.localised_description = {"entity-description.steam_engine"}
    steam_engine.maximum_temperature = steam_engine.maximum_temperature + 35 * i
    steam_engine.placeable_by = {item = CONSTANTS.mod_name .. "-steam-engine-permanent", count = 1}
    data:extend(
        {
            boiler,
            steam_engine
        }
    )
end
