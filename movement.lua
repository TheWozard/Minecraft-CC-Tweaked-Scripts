return {
    new = function()
        return {
            location = vector.new(0, 0, 0),
            direction = vector.new(1, 0, 0),
            infront = function(self)
                return self.location + self.direction
            end,
            behind = function(self)
                return self.location - self.direction
            end,
            above = function(self)
                return self.location + vector.new(0, 0, 1)
            end,
            below = function(self)
                return self.location - vector.new(0, 0, 1)
            end,
            forward = function(self)
                if turtle.forward() then
                    self.location = self:infront()
                    return true
                end
                return false
            end,
            back = function(self)
                if turtle.back() then
                    self.location = self:behind()
                    return true
                end
                return false
            end,
            up = function(self)
                if turtle.up() then
                    self.location = self:above()
                    return true
                end
                return false
            end,
            down = function(self)
                if turtle.down() then
                    self.location = self:below()
                    return true
                end
                return false
            end,
            turnLeft = function(self)
                turtle.turnLeft()
                self.direction = vector.new(-self.direction.y, self.direction.x,
                                            0)
            end,
            turnRight = function(self)
                turtle.turnRight()
                self.direction = vector.new(self.direction.y, -self.direction.x,
                                            0)
            end,
            tostring = function(self)
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
                return "L: " .. self.location:tostring() .. " P: " ..
                           self.direction:tostring() .. " F: " .. facing
            end
        }
    end
}
