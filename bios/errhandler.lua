function love.errorhandler(msg)
    local traceback = debug.traceback()

    local function draw()
        love.graphics.clear(love.graphics.getBackgroundColor())
        love.graphics.setColor(79, 177, 247)
        love.graphics.print("An error has occurred.", 10, 10)
        love.graphics.print(msg, 10, 30)
        love.graphics.print(traceback, 10, 50)
        love.graphics.print("Press Q or Escape to exit.", 10, love.graphics.getHeight() - 30)
        love.graphics.present()
    end

    while true do
        love.event.pump()

        for e, a, b, c in love.event.poll() do
            if e == "quit" then
                return
            elseif e == "keypressed" and (a == "escape" or a == "q") then
                return
            end
        end

        draw()

        if love.timer then
            love.timer.sleep(0.1)
        end
    end
end
