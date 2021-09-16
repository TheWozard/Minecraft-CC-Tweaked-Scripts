local Movement = require("movement")
local Grid = require("grid")

Path = {}

function Path:new()
    local o = {movement = Movement:new(), grid = Grid:new()}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Path:forward()
    self.grid:setPointDiscovered(self.movement.location:infront(), true)
    if self.movement:forward() then
        self.grid:setPointPathable(self.movement.location.position, true)
        return true
    end
    self.grid:setPointPathable(self.movement.location:infront(), false)
    return false
end

function Path:back()
    self.grid:setPointDiscovered(self.movement.location:behind(), true)
    if self.movement:back() then
        self.grid:setPointPathable(self.movement.location.position, true)
        return true
    end
    self.grid:setPointPathable(self.movement.location:behind(), false)
    return false
end

function Path:up()
    self.grid:setPointDiscovered(self.movement.location:above(), true)
    if self.movement:up() then
        self.grid:setPointPathable(self.movement.location.position, true)
        return true
    end
    self.grid:setPointPathable(self.movement.location:above(), false)
    return false
end

function Path:down()
    self.grid:setPointDiscovered(self.movement.location:below(), true)
    if self.movement:down() then
        self.grid:setPointPathable(self.movement.location.position, true)
        return true
    end
    self.grid:setPointPathable(self.movement.location:below(), false)
    return false
end

function Path:drawScreen(screen)
    self.grid:drawPointScreen(self.movement.location.position, screen)
    screen.setCursorPos(1, 1)
    -- screen.clearLine()
    screen.write(self.movement.location:tostring())
    screen.setCursorPos(1, 2)
    -- screen.write(self.grid:getNearestUndiscoveredTo(self.movement.location.position):tostring())
end

function Path:draw() return self:drawScreen(term) end

return Path
