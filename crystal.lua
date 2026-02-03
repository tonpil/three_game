local Crystal = {}
Crystal.__index = Crystal

local COLORS = {"A","B","C","D","E","F"}

function Crystal:new(color)
    local obj = {
        color = color
    }
    setmetatable(obj, self)
    return obj
end 

function Crystal:newFromRandom() 
    return Crystal:new(COLORS[math.random(#COLORS)])
end

return Crystal