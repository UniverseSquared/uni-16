local fs = {}

-- TODO: sandbox these somehow

fs.read = function(path, size)
    return love.filesystem.read(path, size)
end

fs.write = function(path, data, size)
    return love.filesystem.write(path, data, size)
end

fs.load = function(path)
    return love.filesystem.load(path)
end

fs.getItems = function(path, extension)
    local items = love.filesystem.getDirectoryItems(path)
    local extension = extension or true
    if not extension then
        for k, v in pairs(items) do
            local index = nil
            for i = 1, #v do
                if v:sub(i, i) == "." then index = i end
            end
            if index ~= nil then items[k] = v:sub(1, index) end
        end
    end
    return items
end

fs.exists = function(path)
    return love.filesystem.getInfo(path) ~= nil
end

fs.getInfo = function(path)
    return love.filesystem.getInfo(path)
end

return fs
