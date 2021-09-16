local length = 100
local inventory_length = 16

if #arg == 1 then
    length = tonumber(arg[1])
else 
    print("Missing required length argument")
    return
end

turtle.select(1)

function ensureBlock()
    while turtle.getItemCount() == 0 and turtle.getSelectedSlot() < inventory_length do
        turtle.select(turtle.getSelectedSlot() + 1)
    end
    return turtle.getItemCount() ~= 0
end


print("Building "..length.." block bridge")
for i = 1, length, 1 do
    if turtle.detect() then
        print("Ran into something")
        return
    end
    turtle.forward()
    if not ensureBlock() then
        return
    end
    turtle.placeDown()
    turtle.turnRight()
    if not ensureBlock() then
        return
    end
    turtle.place()
    turtle.turnLeft()
    turtle.turnLeft()
    if not ensureBlock() then
        return
    end
    turtle.place()
    turtle.turnRight()
end