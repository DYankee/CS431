
###############################################################################
# AI DISCLOSURE
###############################################################################
# Used Claude Opus 4.6 to create a simple script for generating sample logs.
# Prompt: can you write me a julia script to create a file containing 10,000 random versions of this log: [2026-02-16 13:42:07] INFO 192.168.1.1:8080 - User logged in (Error: 0)
# Result: the generate_logs.jl file attached with the assignment

###############################################################################
# Reflection
###############################################################################
# Results:
# Solution A (Native functions) took 0.048540597 to complete and used 15379472 bytes (15.3MB)
# Solution B (Regex) took 0.05557966 to complete and used 6148000 bytes (6.1MB)
# 
# From the couple tests I ran, the native version of the function appeared to have
# slightly better performance but used almost 3 times the memory.
# In addition to the memory overhead the native version of the function is also extremely
# susceptible to breaking should the format of the log change at all. A good example of this
# is if the IP address gets moved to a new location in the line the native version will
# capture the wrong value.
# 
# In terms of developer experience I found the native version of the function
# much more enjoyable and straight forward to write. Regex on the other hand I don't know 
# very well so I found myself constantly having to reference the mdn regex cheat sheet 
# along with messing around on https://regex101.com to test out and format my statements.
# Despite the steep learning curve I have to admit the regex version feels a lot more robust
# and elegant in a way.


###############################################################################
# Solution A
###############################################################################
function parse_log_native(file)
    for line in eachline(file)
        
        # since the IP address is always the 4th "word" in the line
        # we can just grab it by its index
        parts = split(line)
        ip_val = parts[4]

        # for the error code since its always between the only parentheses 
        # in the line we can look for the first and last occurrences
        # and capture whats between them. 
        err_start_idx = findfirst('(', line)
        err_end_idx = findfirst(')', line)

        if isnothing(err_start_idx) || isnothing(err_end_idx)
            result = "invalid IP address or error format in: ($line)"
        else
            error_val = line[err_start_idx:err_end_idx]
            result = rpad("IP address($ip_val): ", 32) * error_val
        end
        # Print the result
        println(result)
    end
end

###############################################################################
# Solution B
###############################################################################
function parse_log_regex(file)
    # Regex to capture ip and error
    pattern = r"(?P<ip>\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{1,5}\b).*?\((?P<err>(.*?))\)"

    # Read file line by line
    for line in eachline(file)
        parsed_data = match(pattern, line)
        
        # Check if valid matches were found. 
        # If no, return an error message with the line that errored.
        # If yes, format and print them.
        if isnothing(parsed_data[:ip]) || isnothing(parsed_data[:err])
            result = "invalid IP address or error format in: ($line)"
        else
            result = rpad("IP address($(parsed_data[:ip])): ", 32) * parsed_data[:err]
        end
        # Print the result
        println(result)
    end
end

###############################################################################
# Time comparison
###############################################################################

# Call each function once to prevent JIT from affecting performance 
parse_log_native("log_example.log")
parse_log_regex("log_example.log")

# use @timed macro to get function execution time and data use
native_stats = @timed parse_log_native("logs.log")
regex_stats = @timed parse_log_regex("logs.log")

# Print the timing results
println("Solution A (Native functions) took $(native_stats.time) to complete and used $(native_stats.bytes) bytes")
println("Solution B (Regex) took $(regex_stats.time) to complete and used $(regex_stats.bytes) bytes")