local movement = require("movement")

local States = {Success = "s", Failed = "f", Unkown = "?", Complete = "."}

return {
    States = States,
    new = function(starting)
        starting = starting or States.Success
        temp = {
            -- Z,Y,X Order for grid as Z "probably" changes the least.
            grid = {},
            hasLocation = function(self, location)
                return self.grid[location.z] ~= nil and
                           self.grid[location.z][location.y] ~= nil and
                           self.grid[location.z][location.y][location.x] ~= nil
            end,
            isLocation = function(self, location, value)
                return self:getLocation(location) == value
            end,
            getLocation = function(self, location) 
                if not self:hasLocation(location) then
                    return nil
                end
                return self.grid[location.z][location.y][location.x]
            end,
            setLocation = function(self, location, value)
                if self.grid[location.z] == nil then
                    self.grid[location.z] = {}
                end
                if self.grid[location.z][location.y] == nil then
                    self.grid[location.z][location.y] = {}
                end
                self.grid[location.z][location.y][location.x] = value
            end,
            pathBetween = function (self, start, finish)
                local max = #(start - finish)
                print(max)
            end,
            getFilterSurroundingOnLevel = function (self, location, filter)
                local positions = {}
                local target = vector.new(1,0,0)
                for i = 1, 4, 1 do
                    local dest = location + target
                    value = self:getLocation(dest)
                    if filter(value) then
                        table.insert(positions, dest)
                    end
                    -- Rotate 90 Degrees Clockwise
                    target = vector.new(target.y, -target.x, 0)
                end
                return positions
            end,
            draw = function(self, location)
                term.setCursorBlink(false)
                term.clear()
                width, height = term.getSize()
                midx = math.floor(width / 2)
                midy = math.floor(height / 2)
                -- grid
                local layer = self.grid[location.z]
                if layer == nil then return end
                for y, xs in pairs(layer) do
                    local yloc = (-1 * (location.y - y)) + midy
                    if yloc > 1 and yloc < height then
                        for x, value in pairs(xs) do
                            local xloc = (location.x - x) + midx
                            if xloc > 1 and xloc < width then
                                term.setCursorPos(xloc, yloc)
                                if location.x == x and location.y == y then
                                    term.blit(value, "f", "0")
                                else
                                    term.write(value)
                                end
                            end
                        end
                    end
                end
                term.setCursorPos(1, 1)
            end
        }
        temp:setLocation(vector.new(0, 0, 0), starting)
        return temp
    end
}
