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
    self.grid:setPointDiscovered(self.movement:infront(), true)
    if self.movement:forward() then
        self.grid:setPointPathable(self.movement.position, true)
        return true
    end
    self.grid:setPointPathable(self.movement:infront(), false)
    return false
end

function Path:back()
    self.grid:setPointDiscovered(self.movement:behind(), true)
    if self.movement:back() then
        self.grid:setPointPathable(self.movement.position, true)
        return true
    end
    self.grid:setPointPathable(self.movement:behind(), false)
    return false
end

function Path:up()
    self.grid:setPointDiscovered(self.movement:above(), true)
    if self.movement:up() then
        self.grid:setPointPathable(self.movement.position, true)
        return true
    end
    self.grid:setPointPathable(self.movement:above(), false)
    return false
end

function Path:down()
    self.grid:setPointDiscovered(self.movement:below(), true)
    if self.movement:down() then
        self.grid:setPointPathable(self.movement.position, true)
        return true
    end
    self.grid:setPointPathable(self.movement:below(), false)
    return false
end

function Path:pathTo(point)
    local path = self.grid:pathBetween(self.movement, point)
    if path == nil then
        return false
    end
    table.remove(path, 1) -- the first point is where we started
    for _, target in ipairs(path) do
        self:draw()
        print(target:tostring())
        self.movement:pointAt(target)
        if not self:forward() then
            return false
        end
    end
    return self.movement.position:equals(point)
end

function Path:drawScreen(screen)
    self.grid:drawPointScreen(self.movement.position, screen)
    screen.setCursorPos(1, 1)
    -- screen.clearLine()
    screen.write(self.movement:tostring())
    screen.setCursorPos(1, 2)
    -- screen.write(self.grid:getNearestUndiscoveredTo(self.movement.position):tostring())
end

function Path:draw() return self:drawScreen(term) end

return Path
