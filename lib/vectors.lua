local lib = {}

---@param color Color
---@return Color.0
lib.normalize_color = function(color)
    local norm = {r = 0, g = 0, b = 0, a = 1}
    if color == nil then return norm end

    if color[1] ~= nil then norm.r = color[1] end
    if color[2] ~= nil then norm.g = color[2] end
    if color[3] ~= nil then norm.b = color[3] end
    if color[4] ~= nil then norm.a = color[4] end
    if color.r ~= nil then norm.r = color.r end
    if color.g ~= nil then norm.g = color.g end
    if color.b ~= nil then norm.b = color.b end
    if color.a ~= nil then norm.a = color.a end

    return norm
end

---@param a Color
---@param b Color
---@return Color.0
lib.color_mult = function(a, b)
    local a_norm = lib.normalize_color(a)
    local b_norm = lib.normalize_color(b)

    return {r = a_norm.r * b_norm.r, g = a_norm.g * b_norm.g, b = a_norm.b * b_norm.b, a = a_norm.a * b_norm.a}
end

return lib