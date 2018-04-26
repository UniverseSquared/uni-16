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
    game = 2,
    editor = 3
}
local state = states.terminal

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

function clear()
    tBuffer = {""}
    line = 1
end

function safeCall(func, ...)
    if func then
        local ok, err = pcall(func, ...)
        if not ok then print("Error: " .. err) cart = nil state = states.terminal return -1 end
        return 0
    end
end

function getSandbox()
    return sandbox.getSandbox()
end

function OS.load()
    tBuffer = {
        "Loaded sOS version " .. OS._version .. ".",
        "Type 'help' for help.",
        prompt
    }

    editor = require("os.sos.editor.editor")
    graphics = require("os.sos.editor.graphics")
    c = require("api.cart")
    sandbox = require("api.sandbox")
    util = require("api.util")
    sw, sh = gpu.getSize()
    saveDir = love.filesystem.getSaveDirectory()
    
    if util.isMobile() then
        keyboard.open(true)
    end

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
            cart = c.load(args[2], getSandbox())
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
            local carts = fs.getItems("carts")
            print("All carts (" .. #carts .. "):")
            for _, v in pairs(carts) do print(v:sub(0, #v-4)) end
        end
    })
    addCommand({
        name = "exit",
        aliases = {"exit", "shutdown"},
        description = "Exit UNI-16.",
        func = function()
            cpu.shutdown()
        end
    })
    addCommand({
        name = "edit",
        aliases = {"edit", "editor", "nano"},
        description = "Simple editor.",
        func = function(args)
            if #args == 1 then
                print("Usage: edit <file>")
            else
                local ok, msg = editor.loadCart(args[2])
                if not ok then
                    print(msg)
                    return
                end
                state = states.editor
            end
        end
    })
    addCommand({
        name = "folder",
        aliases = {"folder", "dir"},
        description = "Open the save directory in your file explorer.",
        func = function(args)
            print(love.filesystem.getSaveDirectory())
            love.system.openURL("file://" .. love.filesystem.getSaveDirectory())
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
        gpu.setColor(255, 255, 255)
        gpu.printf(join(tBuffer, "\n"), 5, 5, sw)
    elseif state == states.game then
        if cart == nil then
            gpu.print("No game cart loaded.", 20, 20)
        else
            if cart.running then
                safeCall(cart.funcs._draw)
            else
                cart.running = true
                safeCall(cart.funcs._init)
            end
        end
    elseif state == states.editor then
        editor.draw()
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
    elseif state == states.editor then
        editor.keypressed(key, scancode, isrepeat)
        if key == "e" and love.keyboard.isDown("lctrl") then
            state = states.terminal
            editor.reset()
        elseif key == "s" and love.keyboard.isDown("lctrl") then
            editor.save()
            state = states.terminal
        end
    end
end

function OS.textinput(str)
    if state == states.terminal then
        tBuffer[line] = tBuffer[line] .. str
    elseif state == states.editor then
        editor.textinput(str)
    end
end

return OS
