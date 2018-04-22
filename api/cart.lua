local cart = {}

local function split(s, sep)
    local sep, fields = sep, {}
    local pattern = string.format("([^%s]+)", sep)
    s:gsub(pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

function cart.getData(name)
    local content = love.filesystem.read("carts/" .. name .. ".u16")
    local pattern = "^__([a-z]+)__$"
    local lines = split(content, "\n")
    local data = {}
    local category = nil
    for _, line in pairs(lines) do
        local _, _, name = string.find(line, pattern)
        if name then
            data[name] = ""
            category = name
        else
            data[category] = data[category] .. "\n" .. line
        end
    end
    return data
end

function cart.load(name, sandbox)
    local data = {}
    local path = "carts/" .. name .. ".u16"
    local info = love.filesystem.getInfo(path)
    if info == nil then
        return nil, "No such cart '" .. name .. "'."
    end
    local sections = cart.getData(name)
    local luaCode = sections["lua"]
    local func, err = loadstring(luaCode)
    if not func and err then
        return nil, err
    end
    setfenv(func, data)
    local ok, err = pcall(func)
    if not ok then
        return nil, tostring(func)
    end
    local cart = {
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
    return cart
end

return cart
