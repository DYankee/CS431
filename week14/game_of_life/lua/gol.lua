

-- Global Config
WIDTH = 50
HEIGHT = 50
UPDATE_RATE = .5 -- Time between updates

-- Tiles
ALIVE = "O"
DEAD = "."

-- Grid class
local Grid = {}
Grid.__index = Grid

-- Constructor
function Grid.new(width, height)
    local self = setmetatable({}, Grid)

    -- Assign variables
    self.width = width
    self.height = height

    -- Build empty grid
    for y = 1, self.height do
        self[y] = {}
        for x = 1, self.width do
            self[y][x] = 0
        end
    end
    return self
end

-- clear the terminal and print the current grid state
function Grid:display()
    -- clear the terminal
    os.execute("clear")

    local output = ""
    for y = 1, self.height do
        for x = 1, self.width do
            output = output .. (self[y][x] == 1 and ALIVE or DEAD) .. " "
        end
        output = output .. "\n"
    end
    print(output)
end

-- Seed
function Grid:seed(filename, startY, startX)
    local seedFile = io.open(filename, "r")
    if not seedFile then
        print("Could not open file: " .. filename)
        return false
    end

    local curRow = startY
    for line in seedFile:lines() do
        -- Make sure we don't leave the grid
        if curRow <= self.height then
            for i = 1, #line do
                local char = line:sub(i,i)
                local currentCol = startX + i - 1

                -- Make sure we don't leave the grid
                if currentCol <= self.width then
                    if char == "1" then
                        self[curRow][currentCol] = 1
                    else
                        self[curRow][currentCol] = 0
                    end
                end
            end
            curRow = curRow + 1
        end
    end
end

-- Count how many cells a neighbor has
function Grid:countNeighbors(x,y)
    local count = 0
    for dy = -1, 1 do
        for dx = -1, 1 do
            if not (dx == 0 and dy == 0) then
                local ny = (y + dy - 1) % self.height + 1
                local nx = (x + dx - 1) % self.width + 1
                count = count + self[ny][nx]
            end
        end
    end
    return count
end

-- Simulation Class
local Simulation = {}
Simulation.__index = Simulation

-- constructor
function Simulation.new(width, height)
    local self = setmetatable({}, Simulation)
    self.grid = Grid.new(width, height)
end

-- sleep function
function Simulation:sleep(n)
    local t0 = os.clock()
    while os.clock() - t0 <= n do
    end
end

function Simulation:update()
    local newGrid = Grid.new(self.grid.width, self.grid.height)

    for y = 1, self.grid.height do
        newGrid[y] = {}
        for x = 1, self.grid.width do
            local neighborCnt = self.grid:countNeighbors(x,y)
            local currentState = self.grid[y][x]

            if currentState == 1 then
                if neighborCnt < 2 or neighborCnt > 3 then
                    newGrid[y][x] = 0
                else
                    newGrid[y][x] = 1
                end
            else
                if neighborCnt == 3 then
                    newGrid[y][x] = 1
                else
                    newGrid[y][x] = 0
                end
            end
        end
    end
    self.grid = newGrid
end


local function main()
    local seed = arg[1]

    local simulation = Simulation.new(50,50)

    simulation

    grid:display()
    sleep(2)
    
    grid:seed(seed, 1, 1)
    grid:display()

end

main()