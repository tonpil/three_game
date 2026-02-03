local GameModel = require("game")
local View = require("view")

math.randomseed(os.time())

local game = GameModel:new()
game:init()
View:showField(game)

local running = true

while running do
    if not game:hasMoves() then
        print("Нет возможных ходов. Перемешиваем поле...")
        game:mix()
        View:showField(game)
    end

    local input = View:getInput()

    if input == "q" then
        running = false
        print("Goodbye!")

    elseif input then
        local from = { x = input.x, y = input.y }
        local to   = { x = input.x, y = input.y }

        if     input.dir == "r" then to.x = to.x + 1
        elseif input.dir == "l" then to.x = to.x - 1
        elseif input.dir == "u" then to.y = to.y - 1
        elseif input.dir == "d" then to.y = to.y + 1
        end

        if to.x >= 1 and to.x <= 10 and to.y >= 1 and to.y <= 10 then
            game:move(from, to)
            local changed
            local anyChanges = false

            repeat
                changed = game:tick()
                if changed then
                    View:showField(game)
                    anyChanges = true
                end
            until not changed

            if not anyChanges then
                View:showField(game)
            end

        else
            print("Вы ввели не правильные координаты (выход за границы поля)")
        end

    else
        print("Некорректный формат ввода (m x y d или q)")
    end
end
