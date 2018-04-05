local BIOS = {
    _version = "0.1 Beta"
}
local timer = 0
local bootTime = 2
local osName = "sos"
local loaded = false
local os = {}

function BIOS.event(name, a, b, c, d, e, f)
    if timer > bootTime then
        if os[name] then os[name](a, b, c, d, e, f) end
    end
end

function BIOS.load()
    font = love.graphics.getFont()
    fw = font:getWidth(" ")
    fh = font:getHeight()
    sw = love.graphics.getWidth()
    sh = love.graphics.getHeight()
    os = require("os." .. osName .. ".init")
end

function BIOS.update(dt)
    timer = timer + dt

    if timer > bootTime then
        if not loaded then
            if os.load then os.load() end
            loaded = true

            for name, func in pairs(os) do
                BIOS[name] = func
            end
        end
    end
end

function BIOS.draw()
    if timer < bootTime then
        love.graphics.print("Uni-8 BIOS system version " .. BIOS._version, 5, 5)
        love.graphics.print("Press F2 for BIOS settings.", 5, sh - (fh + 5))
    end
end

return BIOS
