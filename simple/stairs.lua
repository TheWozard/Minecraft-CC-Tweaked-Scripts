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
    if detail == nil then
        print("No torches to place")
        os.exit()
    end
    if detail["name"] ~= "minecraft:torch" then
        print("Incorrect torches"..detail["name"].." "..detail["count"])
        os.exit()
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
        turtle.up()
        turtle.digUp()
        turtle.down()
        turtle.digDown()
        turtle.down()
        if not turtle.detectDown() then
            placeBlock()
        end
    end
end

parallel.waitForAny(main,
    function() os.pullEvent("key") end
)