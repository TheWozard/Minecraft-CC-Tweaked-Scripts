local movement = require("movement")
local grids = require("grid")

return {
    new = function()
        return {
            movement = movement.new(),
            grid = grids.new(),
            infront = function(self) return self.movement:infront() end,
            behind = function(self) return self.movement:behind() end,
            above = function(self) return self.movement:above() end,
            below = function(self) return self.movement:below() end,
            forward = function(self)
                if self.movement:forward() then
                    
                    self.grid:setLocation(self.movement.location, grids.States.Success)
                    return true
                end
                self.grid:setLocation(self.movement:infront(), grids.States.Failed)
                return false
            end,
            back = function(self)
                if self.movement:back() then
                    self.grid:setLocation(self.movement.location, grids.States.Success)
                    return true
                end
                self.grid:setLocation(self.movement:behind(), grids.States.Failed)
                return false
            end,
            turnLeft = function(self) return self.movement:turnLeft() end,
            turnRight = function(self)
                return self.movement:turnRight()
            end,
            draw = function(self)
                self.grid:draw(self.movement.location)
                term.setCursorPos(1,1)
                term.clearLine()
                term.write(self.movement:tostring())
            end,
            tostring = function(self)
                return self.movement:tostring()
            end,
        }
    end
}
