local BIOS = {
    _version = "0.2 Beta"
}
local timer = 0
local bootTime = 3
local loaded = false
local mode = 1
local os = {}

function join(arr, delim)
    local str = ""

    for _, v in pairs(arr) do
        str = str .. v .. delim
    end

    return str:sub(1, #str - #delim)
end

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
    osList = love.filesystem.getDirectoryItems("os")
    dList = {}
    for k, v in pairs(osList) do dList[k] = k .. ") " .. v end
    osName = love.filesystem.read("bios/default")
end

function BIOS.update(dt)
    if not loaded then
        if mode == 1 then
            timer = timer + dt

            if timer > bootTime then
                if not loaded then
                    os = require("os." .. osName .. ".init")
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
                love.graphics.print("Uni-16 BIOS system version " .. BIOS._version, 5, 5)
                love.graphics.print("Loading OS " .. osName, 5, 30)
                love.graphics.print("Press F1 for BIOS settings or F2 for boot options.", 5, sh - (fh + 5))
            end
        elseif mode == 2 then
            love.graphics.print("Work in progress", 5, 5)
            love.graphics.print("Press escape to return.", 5, sh - (fh + 5))
        elseif mode == 3 then
            love.graphics.print(join(dList, "\n"), 5, 5)
        end
    end
end

function BIOS.keypressed(key, scancode, isrepeat)
    if mode == 1 then
        if key == "f1" then
            mode = 2
        elseif key == "f2" then
            mode = 3
        end
    elseif mode == 2 then
        if key == "escape" then
            timer = 0
            mode = 1
        end
    elseif mode == 3 then
        local i = tonumber(scancode)
        if osList[i] ~= nil then
            mode = 1
            osName = osList[i]
            os = require("os." .. osName .. ".init")
            timer = bootTime
        end
    end
end

return BIOS
