local m = {}
local _math = math

m.random = function(min, max)
    return love.math.random(min, max)
end

m.seed = function(seed)
    love.math.setRandomSeed(seed)
end

m.floor = function(num)
    return _math.floor(num)
end

m.sin = function(num)
    return _math.sin(num)
end

m.cos = function(num)
    return _math.cos(num)
end

m.tan = function(num)
    return _math.tan(num)
end

return m
