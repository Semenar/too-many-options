local CONSTANTS = require("common.constants")

local lib_prototypes = require("lib.prototypes")

local base_item = lib_prototypes.get_named_prototype("item", "assembling-machine-3")
if base_item then
    for _, machine_name in ipairs({"overclocked-machine", "offshore-machine", "fallout-machine"}) do
        ---@type data.AssemblingMachinePrototype | nil
        local machine = lib_prototypes.get_named_prototype("entity", CONSTANTS.mod_name .. "-" .. machine_name)

        if machine then
            machine.minable = machine.minable or {mining_time = 0.2}
            machine.minable.result = machine.name

            ---@type data.ItemPrototype
            local item = table.deepcopy(base_item)
            item.name = machine.name
            item.icons = table.deepcopy(machine.icons)
            item.icon = nil
            item.icon_size = nil
            item.place_result = item.name
            item.order = (item.order or "") .. "-y[fms]-" .. machine_name
            item.localised_name = {"entity-name." .. item.name}

            data:extend({item})
        end
    end
end