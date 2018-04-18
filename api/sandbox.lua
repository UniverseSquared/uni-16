s = {
    getSandbox = function()
        local sandbox = {}
        sandbox.rect = function(x, y, w, h, color, fill)
            gpu.setColor(unpack(s.pallete[color] or s.pallete[2]))
            gpu.rectangle(x, y, w, h, fill)
        end

        sandbox.circle = function(x, y, r, color, fill)
            gpu.setColor(unpack(s.pallete[color] or s.pallete[2]))
            gpu.circle(x, y, r, fill)
        end

        sandbox.ellipse = function(x, y, r1, r2, color, fill)
            gpu.setColor(unpack(s.pallete[color] or s.pallete[2]))
            gpu.ellipse(x, y, r1, r2, fill)
        end

        sandbox.text = function(str, x, y, color, sx, sy)
            gpu.setColor(unpack(s.pallete[color] or s.pallete[2]))
            local sx = sx or 1
            local sy = sy or 1
            gpu.print(str, x, y, sx, sy)
        end

        sandbox.btn = function(id)
            return keyboard.isDown(s.buttons[id])
        end

        sandbox.floor = function(num)
            return math.floor(num)
        end

        sandbox.sin = function(num)
            return math.sin(num)
        end

        sandbox.cos = function(num)
            return math.cos(num)
        end

        sandbox.tan = function(num)
            return math.tan(num)
        end

        sandbox.rand = function(min, max)
            if not max and min then
                return math.random(0, min)
            end
            local min = min or 0
            local max = max or 1
            return math.random(min, max)
        end

        sandbox.PI = math.pi

        sandbox.add = table.insert

        sandbox.foreach = function(arr, callback)
            for k, v in pairs(arr) do
                callback(v, k, arr)
            end
        end

        sandbox.size = function()
            return gpu.getSize()
        end

        sandbox.time = cpu.time

        sandbox.str = function(x) return tostring(x) end
        return sandbox
    end
}

s.buttons = {
    [1] = "up",
    [2] = "down",
    [3] = "left",
    [4] = "right",
    [5] = "z",
    [6] = "x"
}

s.pallete = {
    [1] = {0, 0, 0}, -- black
    [2] = {255, 255, 255}, -- white
    [3] = {255, 0, 0}, -- red
    [4] = {0, 255, 0}, -- green
    [5] = {0, 0, 255}, -- blue
    [6] = {255, 100, 100}, -- light red
    [7] = {100, 255, 100}, -- light green
    [8] = {100, 100, 255} -- light blue
}

return s
