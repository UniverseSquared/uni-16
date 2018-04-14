local gpu = {}

gpu.print = function(text, x, y, sx, sy)
    local sx = sx or 1
    local sy = sy or 1
    love.graphics.print(text, x, y, 0, sx, sy)
end

gpu.printf = function(text, x, y, limit, align)
    local align = align or "left"

    love.graphics.printf(text, x, y, limit, align)
end

gpu.rectangle = function(x, y, w, h, fill)
    local fill = fill or true
    local mode
    if fill then mode = "fill"
    else mode = "line" end
    love.graphics.rectangle(mode, x, y, w, h)
end

gpu.circle = function(x, y, radius, fill)
    local fill = fill or true
    local mode
    if fill then mode = "fill"
    else mode = "line" end

    love.graphics.circle(mode, x, y, radius)
end

gpu.ellipse = function(x, y, rx, ry, fill)
    local fill = fill or true
    local mode
    if fill then mode = "fill"
    else mode = "line" end

    love.graphics.ellipse(mode, x, y, rx, ry)
end

gpu.setColor = function(r, g, b, a)
    if type(r) == "table" then
        r, g, b, a = unpack(r)
    end

    if r then r = r / 255 end
    if g then g = g / 255 end
    if b then b = b / 255 end
    if a then a = a / 255 end

    love.graphics.setColor(r, g, b, a)
end

gpu.getColor = function()
    local r, g, b, a = love.graphics.getColor()
    local floor = math.floor
    return floor(r * 255), floor(g * 255), floor(b * 255), floor(a * 255)
end

gpu.getSize = function()
    return love.graphics.getWidth(), love.graphics.getHeight()
end

gpu.setFont = function(font)
    love.graphics.setFont(font)
end

gpu.getFont = function()
    return love.graphics.getFont()
end

return gpu
