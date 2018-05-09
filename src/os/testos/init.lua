local OS = {}
local line = "Type what you want here! "

function OS.load()
    cart = require("api.cart")
end

function OS.draw()
    gpu.print("Hello, world!", 5, 5)
    gpu.print(line, 5, 30)
    local image = cart.loadImageData("1234567812345678123456781234567812345678123456781234567812345678")
    local pallete = {
        [1] = {0, 0, 0}, -- black
        [2] = {255, 255, 255}, -- white
        [3] = {255, 0, 0}, -- red
        [4] = {0, 255, 0}, -- green
        [5] = {0, 0, 255}, -- blue
        [6] = {255, 100, 100}, -- light red
        [7] = {100, 255, 100}, -- light green
        [8] = {100, 100, 255} -- light blue
    }
    gpu.image(image, 5, 100, pallete, 16)
end

function OS.textinput(text)
    line = line .. text
end

return OS
