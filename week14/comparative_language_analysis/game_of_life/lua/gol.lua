-- Global Config
WIDTH = 96
HEIGHT = 96
FRAME_COUNT = 500
UPDATE_RATE = .05 -- Time between updates
DEFAULT_SEED = "../seeds/tests/default.txt"

-- Tiles
ALIVE = "\u{2687}"
DEAD = "\u{0387}"


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
        file:write(string.format("%d,%.6f,%.2f,%.6f,%.2f\n", 
            self.frameCount, frameTime, frameMem, avgTime, avgMem))
        file:close()
    end
    
    return avgTime, avgMem
end


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
function Grid:display(stats)
    -- clear the terminal
    os.execute("clear")

    local output = ""
    for y = 1, self.height do
        for x = 1, self.width do
            output = output .. (self[y][x] == 1 and ALIVE or DEAD) .. " "
        end
        output = output .. "\n"
    end

    -- Append performance stats to output
    if stats then
        output = output .. "\n" .. string.rep("-", self.width * 2) .. "\n"
        output = output .. string.format("FRAME: %d\n", stats.count)
        output = output .. string.format("%-5s Current: %6.4f s  | Avg: %6.4f s\n", 
            "TIME:", stats.currTime, stats.avgTime)
        output = output .. string.format("%-5s Current: %6.2f KB | Avg: %6.2f KB\n", 
            "MEM:", stats.currMem, stats.avgMem)
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
    return self
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
    -- init simulation
    local simulation = Simulation.new(WIDTH, HEIGHT)

    -- Load user seed
    local seed = arg[1] or DEFAULT_SEED
    simulation.grid:seed(seed, 1, 1)
    simulation.grid:display()

    -- Setup Tracker
    -- regex to get the seed name from the filename
    local baseName = seed:match("([^/\\]+)%.[^.]+$") or seed:match("([^/\\]+)$") or "seed"
    local outputFile = string.format("lua_%dx%d_%s.csv",
        simulation.grid.width,
        simulation.grid.height,
        baseName
    )
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