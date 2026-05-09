local lib = {}

---@param energy number
---@return string
lib.convert_to_energy = function(energy)
    energy = energy * 60 -- in W
    for _, prefix in ipairs({"", "k", "M", "G", "T", "P", "E", "Z", "Y", "R"}) do
        if energy < 1000 then
            return energy .. prefix .. "W"
        end
        energy = energy / 1000.
    end
    return energy .. "QW"
end

return lib