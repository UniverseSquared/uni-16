local keyboard = {}

keyboard.isDown = function(id)
    return love.keyboard.isDown(id)
end

keyboard.open = function(enabled)
    love.keyboard.setTextInput(enabled)
end

return keyboard
