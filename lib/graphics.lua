local lib = {}

---@param animation data.Animation | data.Sprite | data.SpriteSheet | data.SpriteNWaySheet
---@param scale number
---@return nil
lib.rescale_animation = function(animation, scale)
    if animation.layers then
        for _, layer in ipairs(animation.layers) do
            lib.rescale_animation(layer, scale)
        end
    else
        animation.scale = (animation.scale or 1) * scale
        if animation.shift then
            if animation.shift[1] then animation.shift[1] = animation.shift[1] * scale end
            if animation.shift[2] then animation.shift[2] = animation.shift[2] * scale end
            if animation.shift.x then animation.shift.x = animation.shift.x * scale end
            if animation.shift.y then animation.shift.y = animation.shift.y * scale end
        end
    end
end

---@param icon data.IconData[] | nil
---@param scale number
---@param base_size? integer
---@param include_blank? boolean
---@return data.IconData[]
lib.get_rescaled_icon = function(icon, scale, base_size, include_blank)
    if icon == nil then return {} end
    if base_size == nil then base_size = 64 end
    if include_blank == nil then include_blank = false end
    local ret = {}
    if include_blank then
        table.insert(ret, {
            icon = "__core__/graphics/empty.png",
            icon_size = 64,
            scale = (base_size / 2) / 64
        })
    end
    for _, layer in ipairs(icon) do
        local rescaled_layer = table.deepcopy(layer)
        rescaled_layer.icon_size = rescaled_layer.icon_size or 64
        rescaled_layer.scale = rescaled_layer.scale or (base_size / 2) / rescaled_layer.icon_size
        rescaled_layer.scale = rescaled_layer.scale * scale

        if rescaled_layer.shift then
            if rescaled_layer.shift[1] then rescaled_layer.shift[1] = rescaled_layer.shift[1] * scale end
            if rescaled_layer.shift[2] then rescaled_layer.shift[2] = rescaled_layer.shift[2] * scale end
            if rescaled_layer.shift.x then rescaled_layer.shift.x = rescaled_layer.shift.x * scale end
            if rescaled_layer.shift.y then rescaled_layer.shift.y = rescaled_layer.shift.y * scale end
        end

        table.insert(ret, rescaled_layer)
    end
    return ret
end

return lib