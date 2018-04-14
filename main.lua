function love.load(args)
    bios = require("bios.init")
    font = love.graphics.newFont("assets/Inconsolata.ttf", 20)
    love.graphics.setFont(font)
    modules = {}
    for _, name in pairs(love.filesystem.getDirectoryItems("api/modules")) do
        local moduleName = name:sub(1, #name - 4)
        modules[moduleName] = require("api.modules." .. moduleName)
    end
end

function love.run()
    local args = love.arg.parseGameArguments(arg)
    love.load(args, arg)

    if bios.load then bios.load(args, modules) end

    if love.timer then love.timer.step() end

    local dt = 0

    return function()
        if love.event then
            love.event.pump()
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                end

                bios.event(name, a, b, c, d, e, f)

                if bios[name] then bios[name](a, b, c, d, e, f) end
            end
        end

        if love.timer then dt = love.timer.step() end

        if bios.update then bios.update(dt) end
        bios.event("update", dt)

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())

            bios.draw()
            bios.event("draw")

            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
end
