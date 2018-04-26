local util = {}

function util.isMobile()
    local os = love.system.getOS()
    return os == "Android" or os == "iOS"
end

return util

