-- Conway's Game of Life in Lua
-- Implementation by T3 Chat

local math = require("math")
local os = require("os")

-- Configuration
local WIDTH = 40
local HEIGHT = 20
local DELAY = 0.01 -- Seconds between frames
local ALIVE = "O"
local DEAD = "."

-- Initialize the grid with random states
local function createGrid(width, height)
    local grid = {}
    for y = 1, height do
        grid[y] = {}
        for x = 1, width do
            -- Approximately 20% chance of being alive initially
            grid[y][x] = math.random() > 0.8 and 1 or 0
        end
    end
    return grid
end

-- Count the live neighbors of a cell (Toroidal/Wrapping grid)
local function countNeighbors(grid, x, y)
    local count = 0
    for dy = -1, 1 do
        for dx = -1, 1 do
            if not (dx == 0 and dy == 0) then
                -- Wrap coordinates around the edges
                local ny = (y + dy - 1) % HEIGHT + 1
                local nx = (x + dx - 1) % WIDTH + 1
                count = count + grid[ny][nx]
            end
        end
    end
    return count
end

-- Calculate the next generation
local function updateGrid(grid)
    local newGrid = {}
    for y = 1, HEIGHT do
        newGrid[y] = {}
        for x = 1, WIDTH do
            local neighbors = countNeighbors(grid, x, y)
            local currentState = grid[y][x]

            if currentState == 1 then
                -- Rules for live cells
                if neighbors < 2 or neighbors > 3 then
                    newGrid[y][x] = 0 -- Dies
                else
                    newGrid[y][x] = 1 -- Lives
                end
            else
                -- Rules for dead cells
                if neighbors == 3 then
                    newGrid[y][x] = 1 -- Reproduction
                else
                    newGrid[y][x] = 0 -- Stays dead
                end
            end
        end
    end
    return newGrid
end

-- Print the grid to the console
local function displayGrid(grid)
    -- Clear the terminal screen (works on most systems)
    if os.getenv("os") ~= nil and os.getenv("os"):find("Windows") then
        os.execute("cls")
    else
        os.execute("clear")
    end

    local output = ""
    for y = 1, HEIGHT do
        for x = 1, WIDTH do
            output = output .. (grid[y][x] == 1 and ALIVE or DEAD) .. " "
        end
        output = output .. "\n"
    end
    print(output)
end

-- Simple sleep function
local function sleep(n)
    local t0 = os.clock()
    while os.clock() - t0 <= n do
    end
end

-- Main Loop
local function main()
    math.randomseed(os.time())
    local currentGrid = createGrid(WIDTH, HEIGHT)

    while true do
        displayGrid(currentGrid)
        currentGrid = updateGrid(currentGrid)
        sleep(DELAY)
    end
end

main()