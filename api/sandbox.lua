local pallete = {
    [1] = {0, 0, 0},
    [2] = {255, 255, 255},
    [3] = {255, 0, 0}
}
local buttons = {
    [1] = "up",
    [2] = "down",
    [3] = "left",
    [4] = "right",
    [5] = "z",
    [6] = "x"
}
s = {}

s.rect = function(x, y, w, h, color, fill)
    gpu.setColor(unpack(pallete[color] or pallete[2]))
    gpu.rectangle(x, y, w, h, fill)
end

s.circle = function(x, y, r, color, fill)
    gpu.setColor(unpack(pallete[color] or pallete[2]))
    gpu.circle(x, y, r, fill)
end

s.ellipse = function(x, y, r1, r2, color, fill)
    gpu.setColor(unpack(pallete[color] or pallete[2]))
    gpu.ellipse(x, y, r1, r2, fill)
end

s.text = function(str, x, y, color, sx, sy)
    gpu.setColor(unpack(pallete[color] or pallete[2]))
    local sx = sx or 1
    local sy = sy or 1
    gpu.print(str, x, y, 0, sx, sy)
end

s.btn = function(id)
    return keyboard.isDown(buttons[id])
end

s.floor = function(num)
    return math.floor(num)
end

s.sin = function(num)
    return math.sin(num)
end

s.cos = function(num)
    return math.cos(num)
end

s.tan = function(num)
    return math.tan(num)
end

s.rand = function(min, max)
    if not max and min then
        return math.random(0, min)
    end
    local min = min or 0
    local max = max or 1
    return math.random(min, max)
end

s.PI = math.pi

s.add = table.insert

s.foreach = function(arr, callback)
    for k, v in pairs(arr) do
        callback(v, k, arr)
    end
end

s.size = function()
    return gpu.getSize()
end

s.time = cpu.time

return s
