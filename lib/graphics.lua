local lib = {}

---@param animation data.Animation | data.Sprite | data.SpriteSheet | data.SpriteNWaySheet
---@param scale double
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

return lib