function placeBlock()
    turtle.select(1)
    if turtle.getItemCount() == 0 then
        print("No blocks to place")
        os.exit()
    end
    turtle.placeDown()
end

function placeTorch()
    turtle.select(2)
    detail = turtle.getItemDetail()
    if  detail == nil or detail["name"] ~= "minecraft:torch" then
        return
    end
    turtle.turnRight()
    turtle.placeUp()
    turtle.turnLeft()
end

function main()
    local max = turtle.getFuelLevel()
    for i = 1, max, 1 do
        turtle.dig()
        turtle.forward()
        turtle.digUp()
        if not turtle.detectDown() then
            placeBlock()
        end
        if i % 10 == 1 then
            placeTorch()
            print("remaining fuel"..turtle.getFuelLevel())
        end
    end
end

parallel.waitForAny(main,
    function() os.pullEvent("key") end
)