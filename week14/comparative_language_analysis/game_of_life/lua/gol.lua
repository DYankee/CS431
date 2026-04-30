-------------------------------------------------------------------------------
-- Conway's game of life implemented in Lua. 
-- Simulation settings can be adjusted below in the global configurations

-- optional Args:
--      1. seedFile     - Path to a file containing a starting seed
--      2. height       - height of the simulation
--      3. width        - Width of the simulation
-------------------------------------------------------------------------------

-- Global Config
WIDTH = 24
HEIGHT = 24
FRAME_COUNT = 300
UPDATE_RATE = .1 -- Time between updates in seconds
DEFAULT_SEED = "../seeds/default.txt"

-- Tiles
ALIVE = "\u{2687}" -- ⚇
DEAD = "\u{0387}"  -- ·


-- Performance tracker
local Tracker = {}
Tracker.__index = Tracker

function Tracker.new(filename)
    local self = setmetatable({}, Tracker)
    self.frameCount = 0
    self.totalTime = 0
    self.totalMem = 0
    self.filename = filename

    -- Init log file
    local file, err = io.open(self.filename, "w")
    if file then
        file:write("Frame,CalcTime_s,MemUsage_KB,AvgTime_s,AvgMem_KB\n")
        file:close()
    else
        print("couldn't open file: " .. err)
        os.exit(1)
    end
    return self
end

function Tracker:update(frameTime, frameMem)
    self.frameCount = self.frameCount + 1
    self.totalTime = self.totalTime + frameTime
    self.totalMem = self.totalMem + frameMem
    
    local avgTime = self.totalTime / self.frameCount
    local avgMem = self.totalMem / self.frameCount
    
    -- Log to file
    local file = io.open(self.filename, "a")
    if file then
        file:write(string.format("%d,%8.6f,%8.4f,%8.6f,%8.4f\n", 
            self.frameCount, frameTime, frameMem, avgTime, avgMem))
        file:close()
    end
    
    return avgTime, avgMem
end


-- Grid class
local Grid = {}
Grid.__index = Grid

-- Constructor
function Grid.new(h, w)
    local self = setmetatable({}, Grid)

    -- Assign variables
    self.h = h
    self.w = w

    -- Build empty grid
    for y = 1, self.h do
        self[y] = {}
        for x = 1, self.w do
            self[y][x] = 0
        end
    end
    return self
end

-- clear the terminal and print the current grid state
function Grid:display(stats)
    -- Clear terminal using ANSI escape codes
    io.write("\27[H\27[2J")

    local output = ""
    for y = 1, self.h do
        for x = 1, self.w do
            output = output .. (self[y][x] == 1 and ALIVE or DEAD) .. " "
        end
        output = output .. "\n"
    end

    -- Append performance stats to output
    if stats then
        output = output .. "\n" .. string.rep("-", self.w * 2) .. "\n"
        output = output .. string.format("FRAME: %d\n", stats.count)
        output = output .. string.format("%-5s Current: %8.6f s  | Avg: %8.6f s\n", 
            "TIME:", stats.currTime, stats.avgTime)
        output = output .. string.format("%-5s Current: %8.4f KB | Avg: %8.4f KB\n", 
            "MEM:", stats.currMem, stats.avgMem)
    end
    print(output)
end

-- Seed
function Grid:seed(filename)
    local seedFile = io.open(filename, "r")
    if not seedFile then
        print("Could not open file: " .. filename)
        return false
    end

    -- Read file to get the width and height of the seed
    local lines = {}
    local seedWidth = 0
    for line in seedFile:lines() do
        table.insert(lines, line)
        if #line > seedWidth then
            seedWidth = #line
        end
    end
    seedFile:close()

    local seedHeight = #lines

    -- Calculate centered position
    local startY = math.floor((self.h - seedHeight) / 2) + 1
    local startX = math.floor((self.w - seedWidth) / 2) + 1

    for rowIdx, line in ipairs(lines) do
        local curRow = startY + rowIdx - 1
        -- Make sure we don't leave the grid
        if curRow >= 1 and curRow <= self.h then
            for i = 1, #line do
                local char = line:sub(i,i)
                local currentCol = startX + i - 1

                -- Make sure we don't leave the grid
                if currentCol >= 1 and currentCol <= self.w then
                    self[curRow][currentCol] = (char == "1") and 1 or 0
                end
            end
            curRow = curRow + 1
        end
    end
end

-- Count how many cells a neighbor has
function Grid:countNeighbors(y,x)
    local count = 0
    for dy = -1, 1 do
        for dx = -1, 1 do
            if not (dx == 0 and dy == 0) then
                local ny = (y + dy - 1) % self.h + 1
                local nx = (x + dx - 1) % self.w + 1
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
function Simulation.new(h,w)
    local self = setmetatable({}, Simulation)
    self.grid = Grid.new(h,w)
    return self
end

-- sleep function
function Simulation:sleep(n)
    local t0 = os.clock()
    while os.clock() - t0 <= n do
    end
end

function Simulation:update()
    local newGrid = Grid.new(self.grid.h, self.grid.w)

    for y = 1, self.grid.h do
        for x = 1, self.grid.w do
            local neighborCnt = self.grid:countNeighbors(y,x)
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
    -- init simulation
    local height = tonumber(arg[2]) or HEIGHT
    local width = tonumber(arg[3]) or WIDTH

    local simulation = Simulation.new(height, width)

    -- Load user seed
    local seed = arg[1] or DEFAULT_SEED
    simulation.grid:seed(seed)
    simulation.grid:display()

    -- Setup Tracker
    -- regex to get the seed name from the filename
    local baseName = seed:match("([^/\\]+)%.[^.]+$") or seed:match("([^/\\]+)$") or "seed"
    local outputFile = string.format("lua_%s.csv", baseName)
    local tracker = Tracker.new(outputFile)

    -- simulation loop
    for i = 1, FRAME_COUNT, 1 do
        local startTime = os.clock()
        simulation:update()
        local endTime = os.clock()
        local frameTime = endTime - startTime

        local frameMem = collectgarbage("count")

        local avgTime, avgMem = tracker:update(frameTime,frameMem)

        local stats = {
            count = i,
            currTime = frameTime,
            avgTime = avgTime,
            currMem = frameMem,
            avgMem = avgMem
        }

        simulation.grid:display(stats)

        simulation:sleep(UPDATE_RATE)
    end

end

main()