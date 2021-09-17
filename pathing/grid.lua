local Location = require("location")

Grid = {}

Context = {}

Node = {}

function Context:new()
    local o = {
        pathable = false,
        discovered = false,
        completed = false,
        metadata = nil
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Node:new(cost, location, bias_func, parent)
    local bias = 0
    local o = {cost = cost, bias = bias, location = location, parent = parent}
    if bias_func ~= nil then o.bias = bias_func(o) end
    setmetatable(o, self)
    self.__index = self
    return o
end

function Node:value() return self.cost + self.bias end

function Node:toList()
    if self.parent == nil then return {self.location.position} end
    local list = self.parent:toList()
    table.insert(list, self.location.position)
    return list
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

function Grid:getPointMetadata(point) return
    self:getPointContext(point).metadata end

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

function Grid:setPointMetadata(point, value)
    local context = self:getPointContext(point)
    context.metadata = value
    self:setPointContext(point, context)
end

function Grid:getPointsInRadius(center, radius)
    local points = {center}
    local investigate = {center}
    local index = Grid:new()
    index:setPointDiscovered(center, true)
    while #investigate > 0 do
        local candidate = table.remove(investigate, #investigate)
        local newPoints = {
            candidate + vector.new(1,0,0),
            candidate + vector.new(0,1,0),
            candidate + vector.new(-1,0,0),
            candidate + vector.new(0,-1,0),
        }
        for _, point in ipairs(newPoints) do
            if not index:isPointDiscovered(point) and (center - point):length() < radius then
                table.insert(points, point)
                table.insert(investigate, point)
                index:setPointDiscovered(point, true)
            end
        end
    end
    return points
end

function Grid:search(location, condition_func, bias_func)
    local node = Node:new(0, location, bias_func, nil)
    if condition_func(node) then return node end
    local open = {node}
    local closed = Grid:new()
    while #open > 0 do
        local lowest_index = 1
        for index, target in ipairs(open) do
            if target:value() < open[lowest_index]:value() then
                lowest_index = index
            end
        end

        local candidate = table.remove(open, lowest_index)
        local successors = {
            Node:new(candidate.cost + 1, Location:new(
                         candidate.location:infront(),
                         candidate.location.direction), bias_func, candidate),
            Node:new(candidate.cost + 2,
                     Location:new(candidate.location:right(),
                                  candidate.location:directionRight()),
                     bias_func, candidate),
            Node:new(candidate.cost + 2,
                     Location:new(candidate.location:left(),
                                  candidate.location:directionLeft()),
                     bias_func, candidate),
            Node:new(candidate.cost + 3,
                     Location:new(candidate.location:behind(),
                                  candidate.location:directionBehind()),
                     bias_func, candidate)
        }
        table.sort(successors, function (a,b)
            return a:value() < b:value()
        end)
        for _, successor in ipairs(successors) do
            if condition_func(successor) then return successor end
            if self:isPointPathable(successor.location.position) then
                local metadata = closed:getPointMetadata(successor.location
                                                             .position)
                if metadata == nil or metadata:value() > successor:value() then
                    table.insert(open, successor)
                    closed:setPointMetadata(successor.location.position,
                                            successor)
                end
            end
        end
    end
    return nil
end

function Grid:pathToNearestUndiscovered(location)
    local node = self:search(location, function (node)
        return not self:isPointDiscovered(node.location.position)
    end, function (node)
        local points = self:getPointsInRadius(node.location.position, 3)
        local bias = 0
        for _, point in ipairs(points) do
            if not self:isPointDiscovered(point) then
                -- bias = bias + 1
            elseif not self:isPointPathable(point) then
                bias = bias - 5
            elseif self:isPointDiscovered(point) then
                bias = bias - 1
            end
        end
        return bias
    end)
    if node ~= nil then
        return node:toList()
    end
    return nil
end

function Grid:pathBetween(start, finish)
    local node = self:search(start, function (node)
        return node.location.position:equals(finish)
    end, function (node)
        return (node.location.position - finish):length()
    end)
    if node ~= nil then
        return node:toList()
    end
    return nil
end

function Grid:drawPointScreen(point, screen)
    screen.setCursorBlink(false)
    screen.setCursorPos(1, 1)
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
