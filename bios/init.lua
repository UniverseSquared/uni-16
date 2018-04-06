local BIOS = {
    _version = "0.2 Beta"
}
local timer = 0
local bootTime = 3
local osName = "sos"
local loaded = false
local mode = 1
local os = {}

function BIOS.event(name, a, b, c, d, e, f)
    if loaded then
        if os[name] then os[name](a, b, c, d, e, f) end
    end
end

function BIOS.load(args)
    for _, option in pairs(args) do
        if option == "--skip-bios" or option == "-s" then
            bootTime = 0
        end
    end

    love.filesystem.load("bios/errhandler.lua")()
    
    font = love.graphics.getFont()
    fw = font:getWidth(" ")
    fh = font:getHeight()
    sw = love.graphics.getWidth()
    sh = love.graphics.getHeight()
    os = require("os." .. osName .. ".init")
end

function BIOS.update(dt)
    if not loaded then
        if mode == 1 then
            timer = timer + dt

            if timer > bootTime then
                if not loaded then
                    if os.load then os.load() end
                    loaded = true
                end
            end
        end
    end
end

function BIOS.draw()
    if not loaded then
        if mode == 1 then
            if timer < bootTime then
                love.graphics.print("Uni-8 BIOS system version " .. BIOS._version, 5, 5)
                love.graphics.print("Press F2 for BIOS settings.", 5, sh - (fh + 5))
            end
        elseif mode == 2 then
            love.graphics.print("Work in progress", 5, 5)
            love.graphics.print("Press escape to return.", 5, sh - (fh + 5))
        end
    end
end

function BIOS.keypressed(key, scancode, isrepeat)
    if mode == 1 then
        if key == "f2" then
            mode = 2
        end
    elseif mode == 2 then
        if key == "escape" then
            timer = 0
            mode = 1
        end
    end
end

return BIOS
