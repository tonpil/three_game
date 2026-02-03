local Crystal = require("crystal")

local GameModel = {}
GameModel.__index = GameModel

function GameModel:new()
    local o = {
        width = 10,
        height = 10,
        field = {}
    }
    setmetatable(o, self)
    return o
end

function GameModel:init()
    math.randomseed(os.time())
    for y = 1, self.height do
        self.field[y] = {}
        for x = 1, self.width do
            self.field[y][x] = Crystal:newFromRandom()
        end
    end

    while self:tick() do end
end

function GameModel:move(from, to)
    self.field[from.y][from.x], self.field[to.y][to.x] =
        self.field[to.y][to.x], self.field[from.y][from.x]
end

function GameModel:tick()
    local remove = {}
    local changed = false

    local function mark(x,y)
        remove[y] = remove[y] or {}
        remove[y][x] = true
    end

    for y = 1, self.height do
        for x = 1, self.width do
            local c = self.field[y][x].color
            if c then
                if x <= self.width-2
                and self.field[y][x+1].color == c
                and self.field[y][x+2].color == c then
                    local i = x
                    while i <= self.width and self.field[y][i].color == c do
                        mark(i,y)
                        i = i + 1
                    end
                end
            end
        end
    end

    for y,row in pairs(remove) do
        for x,_ in pairs(row) do
            self.field[y][x] = nil
            changed = true
        end
    end

    if not changed then
        return false
    end

    for x = 1, self.width do
        local stack = {}
        for y = self.height, 1, -1 do
            if self.field[y][x] then
                table.insert(stack, self.field[y][x])
            end
        end
        for y = self.height, 1, -1 do
            self.field[y][x] = table.remove(stack, 1)
        end
    end

    for y = 1, self.height do
        for x = 1, self.width do
            if not self.field[y][x] then
                self.field[y][x] = Crystal:newFromRandom()
            end
        end
    end

    return true
end


function GameModel:hasMatchAt(x, y)
    local c = self.field[y][x]
    if not c then return false end

    local color = c.color

    local len = 1
    while x + len <= self.width and self.field[y][x+len].color == color do
        len = len + 1
    end

    if len >= 3 then return true end
    return false
end

function GameModel:hasMoves()
    for y = 1, self.height do
        for x = 1, self.width do
            if x < self.width then
                self:move({x=x,y=y}, {x=x+1,y=y})
                if self:hasMatchAt(x,y) or self:hasMatchAt(x+1,y) then
                    self:move({x=x,y=y}, {x=x+1,y=y})
                    return true
                end
                self:move({x=x,y=y}, {x=x+1,y=y})
            end

            if y < self.height then
                self:move({x=x,y=y}, {x=x,y=y+1})
                if self:hasMatchAt(x,y) or self:hasMatchAt(x,y+1) then
                    self:move({x=x,y=y}, {x=x,y=y+1})
                    return true
                end
                self:move({x=x,y=y}, {x=x,y=y+1})
            end
        end
    end
    return false
end


function GameModel:hasMatches()
    for y=1,self.height do
        for x=1,self.width do
            if self:hasMatchAt(x,y) then
                return true
            end
        end
    end
    return false
end

function GameModel:mix()
    repeat
        for y = 1, self.height do
            for x = 1, self.width do
                local rx = math.random(self.width)
                local ry = math.random(self.height)
                self.field[y][x], self.field[ry][rx] =
                    self.field[ry][rx], self.field[y][x]
            end
        end
    until self:hasMoves() and not self:hasMatches()
end

function GameModel:dump()
    return self.field
end

return GameModel
