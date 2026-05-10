local CONSTANTS = require("common.constants")

for i = 0, 98 do
    local small_assembler = table.deepcopy(data.raw["assembling-machine"][CONSTANTS.mod_name .. "-small-assembler-1"])
    small_assembler.name = small_assembler.name .. "-faster-" .. tostring(i)
    small_assembler.hidden = true
    small_assembler.hidden_in_factoriopedia = true
    small_assembler.localised_name = {"entity-name." .. CONSTANTS.mod_name .. "-small-assembler-1"}
    small_assembler.localised_description = {"entity-description." .. CONSTANTS.mod_name .. "-small-assembler-1"}
    small_assembler.crafting_speed = small_assembler.crafting_speed + 0.1 * i
    local factor_difference = (0.2 + 0.1 * i) / 0.2
    small_assembler.energy_usage = tostring(factor_difference * 60 * util.parse_energy(small_assembler.energy_usage)) .. "W"
    small_assembler.placeable_by = {item = CONSTANTS.mod_name .. "-small-assembler-1", count = 1}
    data:extend({
        small_assembler
    })
end