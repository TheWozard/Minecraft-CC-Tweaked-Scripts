local Location = require("location")

Movement = {}

function Movement:new()
    local o = {
        location = Location:new()
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Movement:forward()
    if turtle.forward() then
        self.location:to(self.location:infront())
        return true
    end
    return false
end

function Movement:back()
    if turtle.back() then
        self.location:to(self.location:behind())
        return true
    end
    return false
end

function Movement:up()
    if turtle.up() then
        self.location:to(self.location:above())
        return true
    end
    return false
end

function Movement:down()
    if turtle.down() then
        self.location:to(self.location:below())
        return true
    end
    return false
end

function Movement:turnRight()
    turtle.turnRight()
    self.location:face(self.location:directionRight())
end

function Movement:turnLeft()
    turtle.turnLeft()
    self.location:face(self.location:directionLeft())
end

function Movement:pointAt(point)
    local offset = point - self.location.position
    if math.abs(offset.x) >= math.abs(offset.y) then
        offset = vector.new(offset.x / math.abs(offset.x), 0 , 0)
    else 
        offset = vector.new(0 , offset.y / math.abs(offset.y) , 0)
    end
    if offset:equals(self.location.direction) then
        return
    end
    if offset:equals(self:pointRight()) then
        self:turnRight()
    elseif offset:equals(self:pointLeft()) then
        self:turnLeft()
    else
        self:turnRight()
        self:turnRight()
    end
end

function Movement:tostring()
    return self.location:tostring()
end

return Movement
