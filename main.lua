function love.load()
    bios = require("bios.init")
    font = love.graphics.newFont("assets/Inconsolata.ttf", 20)
    love.graphics.setFont(font)
end

function love.run()
    love.load()
    if bios.load then bios.load() end

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

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())

            bios.draw()

            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
end
