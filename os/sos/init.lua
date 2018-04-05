local OS = {
    _version = "0.3 Beta"
}
local tBuffer = {}
local line = 2

function split(s, sep)
    local sep, fields = sep, {}
    local pattern = string.format("([^%s]+)", sep)
    s:gsub(pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

function print(str)
    table.insert(tBuffer, str)
    line = line + 1
end

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

function processCommand(l)
    local args = split(l, " ")
    local cmd = args[1]

    if cmd == "test" then
        print("hello world")
    end
end

function OS.keypressed(key, scancode, isrepeat)
    if key == "backspace" then
        tBuffer[line] = tBuffer[line]:sub(1, #tBuffer[line] - 1)
    elseif key == "return" then
        processCommand(tBuffer[line])
        print("")
    end
end

function OS.textinput(str)
    tBuffer[line] = tBuffer[line] .. str
end

return OS
