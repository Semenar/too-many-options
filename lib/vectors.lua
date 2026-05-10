local lib = {}

---@param color? Color
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

---@param position? MapPosition | Vector
---@return MapPosition.0 | Vector.0
lib.normalize_map_position = function(position)
    local norm = {x = 0, y = 0}
    if position == nil then return norm end

    if position[1] ~= nil then norm.x = position[1] end
    if position[2] ~= nil then norm.y = position[2] end
    if position.x ~= nil then norm.x = position.x end
    if position.y ~= nil then norm.x = position.y end

    return norm
end

---@param bounding_box? BoundingBox
---@return BoundingBox.0
lib.normalize_bounding_box = function(bounding_box)
    local norm = {left_top = lib.normalize_map_position(), right_bottom = lib.normalize_map_position()}
    if bounding_box == nil then return norm end

    if bounding_box[1] ~= nil then norm.left_top = lib.normalize_map_position(bounding_box[1]) end
    if bounding_box[2] ~= nil then norm.right_bottom = lib.normalize_map_position(bounding_box[2]) end
    if bounding_box.left_top ~= nil then norm.left_top = lib.normalize_map_position(bounding_box.left_top) end
    if bounding_box.right_bottom ~= nil then norm.right_bottom = lib.normalize_map_position(bounding_box.right_bottom) end

    return norm
end

---@param bounding_box? BoundingBox
---@return number
lib.bounding_box_area = function(bounding_box)
    local norm = lib.normalize_bounding_box(bounding_box)
    return math.abs((norm.right_bottom.x - norm.left_top.x) * (norm.right_bottom.y - norm.left_top.y))
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