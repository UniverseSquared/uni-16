local editor = {}
local buffer = {{""}}
local cursor = {x = 1, y = 1}
local sw, sh = gpu.getSize()
local f = gpu.getFont()
local fw = f:getWidth(" ")
local fh = f:getHeight()
local file

function join(arr, delim)
    local str = ""

    for _, v in pairs(arr) do
        str = str .. v .. delim
    end

    return str:sub(1, #str - #delim)
end

function split(s, sep)
    local sep, fields = sep, {}
    local pattern = string.format("([^%s]+)", sep)
    s:gsub(pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

function getBufferString()
    local str = ""

    for _, v in pairs(buffer) do
        str = str .. join(v, "") .. "\n"
    end

    return str
end

function getChar(x, y)
    return buffer[y][x]
end

function setChar(x, y, c)
    buffer[y][x] = c
end

function removeChar(x, y)
    table.remove(buffer[y], x)
end

function editor.draw()
    gpu.setColor(255, 255, 255, 255)
    gpu.printf(getBufferString(), 5, 5, sw)
    gpu.setColor(255, 255, 255, 100)
    gpu.rectangle((fw * (cursor.x - 1)) + 5, (fh * (cursor.y - 1)) + 5, fw, fh)
end

function editor.keypressed(key, scancode, isrepeat)
    if key == "up" then
        if cursor.y > 1 then
            cursor.y = cursor.y - 1
            if cursor.x > #buffer[cursor.y] + 1 then
                cursor.x = #buffer[cursor.y] + 1
            end
        end
    elseif key == "down" then
        if cursor.y < #buffer then cursor.y = cursor.y + 1 end
    elseif key == "left" then
        if cursor.x > 1 then cursor.x = cursor.x - 1 end
    elseif key == "right" then
        if cursor.x < #buffer[cursor.y] + 1 then cursor.x = cursor.x + 1 end
    elseif key == "backspace" then
        if cursor.x > 1 then
            removeChar(cursor.x - 1, cursor.y)
            cursor.x = cursor.x - 1
        end
    elseif key == "return" then
        cursor.y = cursor.y + 1
        cursor.x = 1
        table.insert(buffer, cursor.y, {""})
    end
end

function editor.textinput(str)
    table.insert(buffer[cursor.y], cursor.x, str)
    cursor.x = cursor.x + 1
end

function editor.getBuffer()
    return buffer
end

function editor.setBuffer(buf)
    buffer = buf
end

function editor.reset()
    buffer = {{""}}
    cursor = {x = 1, y = 1}
end

function editor.loadFile(fileName)
    editor.reset()
    if not fs.exists(fileName) then
        fs.write(fileName, "")
    else
        local str = fs.read(fileName)
        local buf = split(str, "\n")
        for k, v in pairs(buf) do
            buf[k] = {}
            for i = 1, #v do
                table.insert(buf[k], v:sub(i, i))
            end
        end
        buffer = buf
        if #buffer == 0 then buffer = {{""}} end
    end
    file = fileName
end

function editor.save()
    fs.write(file, getBufferString())
end

return editor
