

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
    local width = width
    local height = height
    for y = 1, height do
        self[y] = {}
        for x = 1, width do
            self[y][x] = 0
        end
    end
    return self
end

function Grid.display()
    local self = setmetatable({}, Grid)

    -- clear the terminal
    os.execute("clear")

    local output = ""
    for y = 1, HEIGHT do
        for x = 1, WIDTH do
            output = output .. (self[y][x] == 1 and ALIVE or DEAD) .. " "
        end
        output = output .. "\n"
    end
    print(output)
end


-- Seed
function Grid.seed(filename, startY, startX)
    local seedFile = io.open(filename, "r")
    if not seedFile then
        print("Could not open file: " .. filename)
        return false
    end

    local curRow = startY
    for line in seedFile:lines() do
        
    end



end



-- Simulation Class
local Simulation = {}
Simulation.__index = Simulation
function Simulation.new(width, height)
    local self = setmetatable({}, Simulation)
    self.grid = Grid.new(width, height)
    self.grid.seed
end




local function createGridFromSeed()

end
