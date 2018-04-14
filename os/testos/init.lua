local OS = {}
local line = "Type what you want here! "

function OS.draw()
    gpu.print("Hello, world!", 5, 5)
    gpu.print(line, 5, 30)
end

function OS.textinput(text)
    line = line .. text
end

return OS
