local lib = {}

---@param type string
---@param name string
---@return data.Prototype | nil
lib.get_named_prototype = function(type, name)
    if defines.prototypes[type] then
        for category, _ in pairs(defines.prototypes[type]) do
            if data.raw[category] and data.raw[category][name] then
                return data.raw[category][name]
            end
        end
    else
        if data.raw[type] then
            return data.raw[type][name]
        end
    end
    return nil
end

return lib