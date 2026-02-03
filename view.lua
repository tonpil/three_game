local View = {}
View.__index = View

local COLORS = {
    A = "\27[31m",
    B = "\27[32m",
    C = "\27[33m",
    D = "\27[34m",
    E = "\27[35m",
    F = "\27[36m"
}
local RESET = "\27[0m"

function View:showField(model)
    local colors = {
        A="\27[31m", B="\27[32m", C="\27[33m",
        D="\27[34m", E="\27[35m", F="\27[36m"
    }
    local reset = "\27[0m"

    for y = 1, model.height do
        for x = 1, model.width do
            local c = model.field[y][x]
            io.write(colors[c.color] .. c.color .. reset .. " ")
        end
        io.write("\n")
    end
end

function View:getInput()
    print("Введите ход: m x y d (lrud) или q")
    local line = io.read()
    if line == "q" then return "q" end

    local _, x, y, d = line:match("(%S)%s+(%d+)%s+(%d+)%s+(%a)")
    if not x then return nil end

    return {
        x = tonumber(x),
        y = tonumber(y),
        dir = d
    }
end

return View
