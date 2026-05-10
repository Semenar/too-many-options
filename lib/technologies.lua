local lib = {}

local lib_strings = require("lib.strings")

---@param technology data.TechnologyPrototype
---@return boolean
lib.is_leveled_technology = function(technology)
    local technology_parts = lib_strings.split(technology.name, "-")
    local candidate_level = tonumber(technology_parts[table_size(technology_parts)])
    if candidate_level ~= nil and tostring(candidate_level) == technology_parts[table_size(technology_parts)] then return true else return false end
end

---@param technology data.TechnologyPrototype
---@return string
lib.get_base_technology_name = function(technology)
    if lib.is_leveled_technology(technology) then
        local technology_parts = lib_strings.split(technology.name, "-")
        technology_parts[table_size(technology_parts)] = nil
        return lib_strings.join(technology_parts, "-")
    else
        return technology.name
    end
end

---@param technology data.TechnologyPrototype | LuaTechnologyPrototype
---@return number
lib.get_technology_level = function(technology)
    local technology_parts = lib_strings.split(technology.name, "-")
    local candidate_level = tonumber(technology_parts[table_size(technology_parts)])
    if candidate_level ~= nil and tostring(candidate_level) == technology_parts[table_size(technology_parts)] then return candidate_level else return 1 end
end

---@param technology data.TechnologyPrototype
---@return LocalisedString
lib.get_localised_name = function(technology)
    if technology.localised_name then return table.deepcopy(technology.localised_name) or "" end
    if lib.is_leveled_technology(technology) then
        return {"", {"technology-name." .. lib.get_base_technology_name(technology)}, tostring(lib.get_technology_level(technology))}
    else
        return {"technology-name." .. technology.name}
    end
end

return lib