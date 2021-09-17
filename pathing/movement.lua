local Location = require("location")

Movement = Location:new()

function Movement:new()
    local o = Location:new()
    setmetatable(o, self)
    self.__index = self
    return o
end

function Movement:forward()
    if turtle.forward() then
        self:to(self:infront())
        return true
    end
    return false
end

function Movement:back()
    if turtle.back() then
        self:to(self:behind())
        return true
    end
    return false
end

function Movement:up()
    if turtle.up() then
        self:to(self:above())
        return true
    end
    return false
end

function Movement:down()
    if turtle.down() then
        self:to(self:below())
        return true
    end
    return false
end

function Movement:turnRight()
    turtle.turnRight()
    self:face(self:directionRight())
end

function Movement:turnLeft()
    turtle.turnLeft()
    self:face(self:directionLeft())
end

function Movement:pointAt(point)
    local offset = point - self.position
    if math.abs(offset.x) >= math.abs(offset.y) then
        offset = vector.new(offset.x / math.abs(offset.x), 0 , 0)
    else 
        offset = vector.new(0 , offset.y / math.abs(offset.y) , 0)
    end
    if offset:equals(self.direction) then
        return
    end
    if offset:equals(self:directionRight()) then
        self:turnRight()
    elseif offset:equals(self:directionLeft()) then
        self:turnLeft()
    else
        self:turnRight()
        self:turnRight()
    end
end

function Movement:tostring()
    return Location.tostring(self)
end

return Movement
