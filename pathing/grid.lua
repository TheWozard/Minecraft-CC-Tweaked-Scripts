Grid = {}

Context = {}

function Context:new()
    local o = {pathable = false, discovered = false, completed = false}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Grid:new()
    local o = {grid = {}}
    setmetatable(o, self)
    self.__index = self
    o:setPointPathable(vector.new(0, 0, 0), true)
    o:setPointDiscovered(vector.new(0, 0, 0), true)
    return o
end

function Grid:hasPoint(point)
    return self.grid[point.z] ~= nil and self.grid[point.z][point.y] ~= nil and
               self.grid[point.z][point.y][point.x] ~= nil
end

function Grid:getPointContext(point)
    if not self:hasPoint(point) then return Context:new() end
    return self.grid[point.z][point.y][point.x]
end

function Grid:setPointContext(point, context)
    if self.grid[point.z] == nil then self.grid[point.z] = {} end
    if self.grid[point.z][point.y] == nil then
        self.grid[point.z][point.y] = {}
    end
    self.grid[point.z][point.y][point.x] = context
end

function Grid:isPointPathable(point)
    return self:getPointContext(point).pathable == true
end

function Grid:isPointDiscovered(point)
    return self:getPointContext(point).discovered == true
end

function Grid:isPointCompleted(point)
    return self:getPointContext(point).completed == true
end

function Grid:setPointPathable(point, value)
    local context = self:getPointContext(point)
    context.pathable = value
    self:setPointContext(point, context)
end

function Grid:setPointDiscovered(point, value)
    local context = self:getPointContext(point)
    context.discovered = value
    self:setPointContext(point, context)
end

function Grid:setPointCompleted(point, value)
    local context = self:getPointContext(point)
    context.completed = value
    self:setPointContext(point, context)
end

function Grid:getNearestUndiscoveredTo(point)
    local options = {}
    local index = Grid:new()
    table.insert(options, point)
    while #options > 0 do
        local newOptions = {}
        for _, option in ipairs(options) do
            -- check all 4 directions from a point
            local target = vector.new(1, 0, 0)
            for i = 1, 4 do
                local destination = option + target
                local context = self:getPointContext(destination)
                if context.discovered == false then
                    -- exit case, we found an undiscovered point
                    return destination
                end
                if (context.pathable or not context.discovered) and
                    not index:hasPoint(destination) then
                    index:setPointCompleted(destination, true)
                    table.insert(newOptions, destination)
                end
                -- Rotate 90 Degrees Clockwise
                target = vector.new(target.y, -target.x, 0)
            end
        end
        options = newOptions
    end
    return
end

function Grid:drawPointScreen(point, screen)
    screen.setCursorBlink(false)
    screen.setCursorPos(1,1)
    screen.clear()

    local layer = self.grid[point.z]
    if layer == nil then return end

    local width, height = screen.getSize()
    local midx = math.ceil(height / 2)
    local midy = math.ceil(width / 2)

    -- drawing grid
    for y, xs in pairs(layer) do
        -- drawing a line of y
        local yloc = math.floor((point.y - y) + midy)
        if yloc >= 1 and yloc <= width then
            for x, context in pairs(xs) do
                -- drawing each x
                local xloc = math.floor((point.x - x) + midx)
                if xloc >= 1 and xloc <= height then
                    -- set draw location
                    screen.setCursorPos(yloc, xloc)
                    local symbol = " "
                    if context.completed == true then
                        symbol = "."
                    end
                    if not context.pathable then
                        -- wall
                        screen.blit(symbol, "f", "8")
                    elseif context.discovered == true then
                        -- floor
                        screen.blit(symbol, "f", "7")
                    end
                end
            end
        end
    end
    term.setCursorPos(1, 1)
end

function Grid:drawPoint(point) return self:drawPointScreen(point, term) end

return Grid
