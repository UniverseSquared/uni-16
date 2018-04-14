local CPU = {}

CPU.shutdown = function()
    love.event.quit()
end

CPU.time = function()
    return os.time()
end

return CPU
