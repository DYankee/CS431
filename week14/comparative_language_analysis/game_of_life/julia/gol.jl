using Printf
using Statistics

# --- Global Config ---
const WIDTH = 24
const HEIGHT = 24
const FRAME_COUNT = 250
const UPDATE_RATE = 0.1 # Seconds
const DEFAULT_SEED = "../seeds/default.txt"

# Tiles (Unicode strings)
const ALIVE = "\u2687" # ⚇
const DEAD  = "\u0387" # ·

# Performance Tracker 
mutable struct PerformanceTracker
    frame_count::Int
    total_time::Float64
    total_mem::Float64
    filename::String

    function PerformanceTracker(filename::String)
        # Initialize log file with header
        open(filename, "w") do io
            println(io, "Frame,CalcTime_s,MemUsage_KB,AvgTime_s,AvgMem_KB")
        end
        new(0, 0.0, 0.0, filename)
    end
end

function update_tracker!(tracker::PerformanceTracker, frame_time::Float64, frame_mem::Float64)
    tracker.frame_count += 1
    tracker.total_time += frame_time
    tracker.total_mem += frame_mem

    avg_time = tracker.total_time / tracker.frame_count
    avg_mem = tracker.total_mem / tracker.frame_count

    # Append to log file
    open(tracker.filename, "a") do io
        @printf(io, "%d,%.4f,%.2f,%.4f,%.2f\n", 
                tracker.frame_count, frame_time, frame_mem, avg_time, avg_mem)
    end

    return avg_time, avg_mem
end

# --- Grid Logic ---

function create_grid(w::Int, h::Int)
    return zeros(Int8, h, w) # Height is rows, Width is columns
end

function count_neighbors(grid::Matrix{Int8}, y::Int, x::Int)
    h, w = size(grid)
    count = 0
    for dy in -1:1, dx in -1:1
        (dy == 0 && dx == 0) && continue
        
        # Toroidal wrapping logic
        ny = mod1(y + dy, h)
        nx = mod1(x + dx, w)
        
        count += grid[ny, nx]
    end
    return count
end

function seed_grid!(grid::Matrix{Int8}, filename::String)
    if !isfile(filename)
        println("Could not open file: $filename")
        return false
    end

    lines = readlines(filename)
    seed_h = length(lines)
    seed_w = maximum(length, lines)

    grid_h, grid_w = size(grid)
    
    # Calculate centered position
    start_x = floor(Int, (grid_w - seed_w) / 2) + 1
    start_y = floor(Int, (grid_h - seed_h) / 2) + 1

    for (row_idx, line) in enumerate(lines)
        cur_y = start_y + row_idx - 1
        for (col_idx, char) in enumerate(line)
            cur_x = start_x + col_idx - 1
            if 1 <= cur_y <= grid_h && 1 <= cur_x <= grid_w
                grid[cur_y, cur_x] = (char == '1') ? 1 : 0
            end
        end
    end
end

function display_grid(grid::Matrix{Int8}, stats::Union{NamedTuple, Nothing}=nothing)
    # Clear terminal using ANSI escape codes
    print("\033[2J\033[H")
    
    h, w = size(grid)
    output = IOBuffer()

    for y in 1:h
        for x in 1:w
            print(output, grid[y, x] == 1 ? ALIVE : DEAD, " ")
        end
        print(output, "\n")
    end

    if stats !== nothing
        println(output, "\n", "-" ^ (w * 2))
        @printf(output, "FRAME: %d\n", stats.count)
        @printf(output, "%-5s Current: %6.4f s  | Avg: %6.4f s\n", "TIME:", stats.currTime, stats.avgTime)
        @printf(output, "%-5s Current: %6.2f KB | Avg: %6.2f KB\n", "MEM:", stats.currMem, stats.avgMem)
    end

    print(String(take!(output)))
end

# --- Simulation Logic (Functional Approach) ---

function update_grid(grid::Matrix{Int8})
    h, w = size(grid)
    
    # Using a functional map construction to create the new grid
    # CartesianIndices allows us to iterate over coordinates functionally
    return [
        begin
            n = count_neighbors(grid, idx[1], idx[2])
            current = grid[idx]
            if current == 1
                (n == 2 || n == 3) ? Int8(1) : Int8(0)
            else
                (n == 3) ? Int8(1) : Int8(0)
            end
        end 
        for idx in CartesianIndices(grid)
    ]
end

# --- Main ---

function main()
    # Handle arguments
    seed_file = length(ARGS) >= 1 ? ARGS[1] : DEFAULT_SEED
    width = length(ARGS) >= 2 ? parse(Int, ARGS[2]) : WIDTH
    height = length(ARGS) >= 3 ? parse(Int, ARGS[3]) : HEIGHT

    grid = create_grid(width, height)
    seed_grid!(grid, seed_file)

    # Determine filename for CSV
    base_name = splitext(basename(seed_file))[1]
    output_file = "julia_$(base_name).csv"
    tracker = PerformanceTracker(output_file)

    for i in 1:FRAME_COUNT
        # Timing and memory measurement
        # gc_live_bytes() provides a view of current heap usage
        start_time = time()
        
        # Generate the new grid
        grid = update_grid(grid)
        
        frame_time = time() - start_time
        frame_mem = Base.gc_live_bytes() / 1024.0

        avg_time, avg_mem = update_tracker!(tracker, frame_time, frame_mem)

        stats = (
            count = i,
            currTime = frame_time,
            avgTime = avg_time,
            currMem = frame_mem,
            avgMem = avg_mem
        )

        display_grid(grid, stats)
        sleep(UPDATE_RATE)
    end
end

# Run the program
main()