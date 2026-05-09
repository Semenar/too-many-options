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

---@param str string
---@param split string
---@return string[]
lib.split = function(str, split)
    local res = {}
    ---@type integer | nil
    local last_pos = 0
    while last_pos ~= nil do
        local pos_start, pos_end = str:find(split, last_pos + 1, true)
        if pos_start == nil then pos_start = str:len() + 1 end
        table.insert(res, str:sub(last_pos + 1, pos_start - 1))
        last_pos = pos_end
    end
    return res
end

---@param strs string[]
---@param sep string
---@return string
lib.join = function(strs, sep)
    local ret = ""
    for _, str in ipairs(strs) do
        if ret ~= "" then ret = ret .. sep end
        ret = ret .. str
    end
    return ret
end

return lib