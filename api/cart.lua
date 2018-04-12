local cart = {}

function cart.load(name)
    local data = {}
    local path = "carts/" .. name .. ".u16"
    local info = love.filesystem.getInfo(path)
    if info == nil then
        return nil, "No such cart '" .. name .. "'."
    end
    local ok, func = pcall(love.filesystem.load, "carts/" .. name .. ".u16")
    if not ok then
        return nil, tostring(func)
    end
    setfenv(func, data)
    local ok, err = pcall(func)
    if not ok then
        return nil, tostring(func)
    end
    local sandbox = getSandbox()
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
