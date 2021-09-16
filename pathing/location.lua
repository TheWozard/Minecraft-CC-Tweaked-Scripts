Location = {}

function Location:new()
    local o = {position = vector.new(0, 0, 0), direction = vector.new(1, 0, 0)}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Location:infront() return self.position + self.direction end

function Location:behind() return self.position - self.direction end

function Location:above() return self.position + vector.new(0, 0, 1) end

function Location:below() return self.position + vector.new(0, 0, -1) end

function Location:right() return self.position + self:directionRight() end

function Location:left() return self.position + self:directionLeft() end

function Location:directionRight()
    return vector.new(self.direction.y, -self.direction.x, 0)
end

function Location:directionLeft()
    return vector.new(-self.direction.y, self.direction.x, 0)
end

function Location:to(position)
    self.position = position
end

function Location:face(direction)
    self.direction = direction
end

function Location:tostring()
    local facing = "Unkown"
    if self.direction.x < 0 then
        facing = "-X"
    elseif self.direction.x > 0 then
        facing = "+X"
    elseif self.direction.y > 0 then
        facing = "+Y"
    elseif self.direction.y < 0 then
        facing = "-Y"
    end
    return "P: " .. self.position:tostring() .. " D: " .. facing
end

return Location
