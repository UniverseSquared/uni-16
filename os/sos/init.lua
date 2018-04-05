local OS = {
    _version = "0.2 Beta"
}
local tBuffer = {}
local line = 2

function OS.load()
    tBuffer = {
        "Loaded SOS version " .. OS._version .. ".",
        ""
    }
end

function OS.draw()
    for i = 1, #tBuffer do
        love.graphics.print(tBuffer[i], 5, 5 + fh * (i - 1))
    end
end

function OS.keypressed(key, scancode, isrepeat)
    if key == "backspace" then
        tBuffer[line] = tBuffer[line]:sub(1, #tBuffer[line] - 1)
    end
end

function OS.textinput(str)
    tBuffer[line] = tBuffer[line] .. str
end

return OS
