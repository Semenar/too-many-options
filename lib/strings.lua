local lib = {}

---@param str string
---@param prefix string
---@return boolean
lib.starts_with = function(str, prefix)
    return str:sub(1, prefix:len()) == prefix
end

---@param str string
---@param suffix string
---@return boolean
lib.ends_with = function(str, suffix)
    return str:sub(str:len() - suffix:len() + 1) == suffix
end

return lib