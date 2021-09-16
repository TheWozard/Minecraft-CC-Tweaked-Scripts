local locations = {}
local x, y = 0, 0
local facing = 0

function turnRight()
    turtle.turnRight()
    facing = (facing + 1) % 4
end

function turnLeft()
    turtle.turnLeft()
    facing = (facing - 1) % 4
end

function forward()
    if not turtle.forward() then
        return false
    end
    x, y = project(facing, 1)
    return true
end

function back()
    if not turtle.back() then
        return false
    end
    x, y = project(facing, -1)
    return true
end

function project(direction, modifier)
    direction = direction % 4
    if direction == 0 then
        return x + modifier, y
    elseif direction == 1 then
        return x, y + modifier
    elseif direction == 2 then
        return x - modifier, y
    elseif direction == 3 then
        return x, y - modifier
    end
end

function isOK(direction, modifier)
    local new_x, new_y = project(direction, modifier)
    key = new_x..","..new_y
    return locations[key] == nil
end

function complete(direction, modifier)
    local new_x, new_y = project(direction, modifier)
    key = new_x..","..new_y
    locations[key] = true
end

function face(direction)
    local tureDirection = direction % 4
    if tureDirection == facing then
        return
    end
    local rightTurns = (tureDirection - facing) % 4
    local leftTurns = (4-rightTurns)
    if leftTurns < rightTurns then
        for i = 1, leftTurns, 1 do
            turnLeft()
        end
    else
        for i = 1, rightTurns, 1 do
            turnRight()
        end
    end
end

function empty()
    local count = 0
    while turtle.placeDown() do
        if not turtle.refuel() then
            return count
        else
            count = count + 1
        end
    end
    return count
end

function clearForward()
    complete(facing, 1)
    if not forward() then
        return
    end
    local count = empty()
    if count == 0 then
        back()
        return
    end
    check()
    back()
end

function check()
    local context = facing
    if isOK(context, 1) then
        clearForward()
    end
    if isOK(context+1, 1) then
        face(context+1)
        clearForward()
    end
    if isOK(context+3, 1) then
        face(context+3)
        clearForward()
    end
    face(context)
end

print("Start "..turtle.getFuelLevel())

turtle.forward()
check()
turtle.back()

print("End "..turtle.getFuelLevel())