local keyboard = {}

keyboard.isDown = function(id)
    return love.keyboard.isDown(id)
end

return keyboard
