using Printf
using Dates
using Random

# Define specific scenarios so the data makes sense
# Format: (Level, Message, ErrorCodeRange)
const SCENARIOS = [
    ("INFO",  "User logged in", 0:0),
    ("INFO",  "Database query successful", 0:0),
    ("INFO",  "File uploaded successfully", 0:0),
    ("WARN",  "High memory usage detected", 101:105),
    ("WARN",  "Slow response from disk", 200:202),
    ("WARN",  "Connection timeout", 408:408),
    ("ERROR", "Database connection failed", 500:505),
    ("ERROR", "Permission denied for user", 403:403),
    ("ERROR", "Critical system failure", 999:999),
    ("DEBUG", "Cache hit for user session", 0:0),
    ("DEBUG", "Verbose packet inspection", 0:0)
]

function generate_logs(filename::String, count::Int)
    open(filename, "w") do io
        println("Generating $count logs...")
        
        start_dt = DateTime(2026, 1, 1, 0, 0, 0)

        for i in 1:count
            # 1. Pick a random scenario first
            level, msg, err_range = rand(SCENARIOS)
            
            # 2. Pick an error code from that scenario's specific range
            err_code = rand(err_range)

            # 3. Generate random timestamp and networking info
            random_seconds = rand(0:(90 * 24 * 60 * 60))
            dt = start_dt + Second(random_seconds)
            timestamp = Dates.format(dt, "yyyy-mm-dd HH:MM:SS")
            
            ip_last_octet = rand(1:254)
            port = rand(1024:9999)

            # 4. Format the line
            log_line = @sprintf(
                "[%s] %-5s 192.168.1.%d:%d - %s (Error: %d)\n",
                timestamp, level, ip_last_octet, port, msg, err_code
            )

            write(io, log_line)
        end
    end
    println("Done! Log file is ready.")
end

generate_logs("logs.log", 10000)