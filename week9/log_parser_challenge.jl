
#############################
# Solution A
#############################


#############################
# Solution B
#############################
function parse_log_regex(file)
    # regex captures
    ip_regex = r"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{1,4}\b"
    error_regex = r"\((.*?)\)"

    for line in eachline(file)
        ip_address = match(ip_regex, line).match
        error_code = match(error_regex, line).match
        println("ip: $ip_address error code: $error_code")
    end
end


#############################
# Time comparison
#############################

@time parse_log_regex("logs.log")