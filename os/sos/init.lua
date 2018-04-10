local OS = {
    _version = "0.3 Beta"
}
local tBuffer = {}
local line = 3
local prompt = "> "
local commands = {}
local cart = nil
local states = {
    terminal = 1,
    game = 2
}
local state = states.terminal
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

function setColor(r, g, b, a)
    if type(r) == "table" then
        r, g, b, a = unpack(r)
    end

    if r then r = r / 255 end
    if g then g = g / 255 end
    if b then b = b / 255 end
    if a then a = a / 255 end

    love.graphics.setColor(r, g, b, a)
end

function getColor()
    local r, g, b, a = love.graphics.getColor()
    local floor = math.floor
    return floor(r * 255), floor(g * 255), floor(b * 255), floor(a * 255)
end

function print(str)
    table.insert(tBuffer, str)
    line = line + 1
end

function addCommand(info)
    table.insert(commands, info)
end

function clear()
    tBuffer = {""}
    line = 1
end

function safeCall(func, ...)
    if func then
        local ok, err = pcall(func, ...)
        if not ok then print("Error: " .. err) return -1 end
        return 0
    end
end

function getSandbox()
    return {
        rect = function(x, y, w, h, color, fill)
            setColor(unpack(pallete[color] or pallete[2]))
            local mode = "line"
            local fill = fill or true
            if fill then mode = "fill" end
            love.graphics.rectangle(mode, x, y, w, h)
        end,
        circle = function(x, y, r, color, fill)
            setColor(unpack(pallete[color] or pallete[2]))
            local mode = "line"
            if fill then mode = "fill" end
            love.graphics.circle(mode, x, y, r)
        end,
        ellipse = function(x, y, r1, r2, color, fill)
            setColor(unpack(pallete[color] or pallete[2]))
            local mode = "line"
            if fill then mode = "fill" end
            love.graphics.ellipse(mode, x, y, r1, r2)
        end,
        btn = function(id)
            return love.keyboard.isDown(buttons[id])
        end,
        floor = function(num)
            return math.floor(num)
        end,
        sin = function(num)
            return math.sin(num)
        end,
        cos = function(num)
            return math.cos(num)
        end,
        tan = function(num)
            return math.tan(num)
        end,
        add = table.insert,
        foreach = function(arr, callback)
            for k, v in pairs(arr) do
                callback(v, k, arr)
            end
        end,
        size = function()
            return
        end,
        PI = math.pi
    }
end

function loadCart(name)
    local data = {}
    local path = "carts/" .. name .. ".u16"
    local info = love.filesystem.getInfo(path)
    if info == nil then
        print("No such cart '" .. name .. "'.")
        return
    end
    local ok, func = pcall(love.filesystem.load, "carts/" .. name .. ".u16")
    if not ok then
        print("Error: " .. tostring(func))
        return
    end
    setfenv(func, data)
    local ok, err = pcall(func)
    if not ok then
        print("Error: " .. tostring(err))
        return
    end
    local sandbox = getSandbox()
    cart = {
        funcs = {},
        running = false
    }
    for name, func in pairs(data) do
        if type(func) == "function" then
            cart.funcs[name] = func
            setfenv(cart.funcs[name], sandbox)
        else
            sandbox[name] = func
        end
    end
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
            else
                local program = args[2]
                for i = 1, #commands do
                    for j = 1, #commands[i].aliases do
                        if commands[i].aliases[j] == program then
                            local cmd = commands[i]
                            print(cmd.name .. " - aliases: " .. join(cmd.aliases, ", "))
                            print("")
                            print(cmd.description)
                            return
                        end
                    end
                end
            end
        end
    })
    addCommand({
        name = "clear",
        aliases = {"clear", "cls"},
        description = "Clear the screen.",
        func = function(args)
            clear()
        end
    })
    addCommand({
        name = "load",
        aliases = {"load"},
        description = "Loads a game cart into memory.",
        func = function(args)
            loadCart(args[2])
        end
    })
    addCommand({
        name = "run",
        aliases = {"run"},
        description = "Runs the loaded cart.",
        func = function(args)
            safeCall(cart.funcs._init)
            state = states.game
        end
    })
    addCommand({
        name = "list",
        aliases = {"list", "ls", "dir"},
        description = "List all carts in the 'carts' folder.",
        func = function()
            local carts = love.filesystem.getDirectoryItems("carts")
            print("All carts (" .. #carts .. "):")
            for _, v in pairs(carts) do print(v:sub(0, #v-4)) end
        end
    })
end

function OS.update(dt)
    if state == states.game then
        safeCall(cart.funcs._update, dt)
    end
end

function OS.draw()
    if state == states.terminal then
        setColor(255, 255, 255)
        love.graphics.printf(join(tBuffer, "\n"), 5, 5, love.graphics.getWidth())
    elseif state == states.game then
        if cart == nil then
            love.graphics.print("No game cart loaded.", 20, 20)
        else
            if cart.running then
                safeCall(cart.funcs._draw)
            else
                cart.running = true
                safeCall(cart.funcs._init)
            end
        end
    end
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
    if key == "escape" then
        if state == states.terminal then state = states.game
        elseif state == states.game then state = states.terminal end
    end
    if state == states.terminal then
        if key == "backspace" then
            if tBuffer[line] ~= prompt then tBuffer[line] = tBuffer[line]:sub(1, #tBuffer[line] - 1) end
        elseif key == "return" then
            processCommand(tBuffer[line])
            print(prompt)
        end
    end
end

function OS.textinput(str)
    if state == states.terminal then
        tBuffer[line] = tBuffer[line] .. str
    end
end

return OS
