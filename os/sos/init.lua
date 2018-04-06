local OS = {
    _version = "0.3 Beta"
}
local tBuffer = {}
local line = 3
local prompt = "> "
local commands = {}

function split(s, sep)
    local sep, fields = sep, {}
    local pattern = string.format("([^%s]+)", sep)
    s:gsub(pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

function join(arr, delim)
    local str = ""

    for _, v in pairs(arr) do
        str = str .. v .. delim
    end

    return str:sub(1, #str - #delim)
end

function print(str)
    table.insert(tBuffer, str)
    line = line + 1
end

function addCommand(info)
    table.insert(commands, info)
end

function OS.load()
    tBuffer = {
        "Loaded sOS version " .. OS._version .. ".",
        "Type 'help' for help.",
        prompt
    }

    addCommand({
        name = "help",
        aliases = {"help", "man"},
        description = "Provides a list of commands and information about them.",
        func = function(args)
            if #args == 1 then
                print("List of available commands:")
                local out = ""
                for i = 1, #commands do
                    out = out .. commands[i].name .. ", "
                end
                out = out:sub(1, #out - 2)
                print(out)
            end
        end
    })
end

function OS.draw()
    love.graphics.printf(join(tBuffer, "\n"), 5, 5, love.graphics.getWidth())
end

function processCommand(l)
    local args = split(l:sub(#prompt), " ")
    local cmd = args[1]

    for i = 1, #commands do
        for j = 1, #commands[i].aliases do
            if commands[i].aliases[j] == cmd then
                commands[i].func(args)
                return
            end
        end
    end

    print("No such command.")
end

function OS.keypressed(key, scancode, isrepeat)
    if key == "backspace" then
        tBuffer[line] = tBuffer[line]:sub(1, #tBuffer[line] - 1)
    elseif key == "return" then
        processCommand(tBuffer[line])
        print(prompt)
    end
end

function OS.textinput(str)
    tBuffer[line] = tBuffer[line] .. str
end

return OS
