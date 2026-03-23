#######################################
# Task 1: The Debugging Macro
#######################################

macro inspect(expression)
    expression_str = string(expression)
    quote
        println("Execution expression: ", $expression_str)
        println($(esc(expression)))
    end
end


println("=== Task 1: @inspect Macro ===")
@inspect 5 + 10
@inspect sqrt(144)
@inspect [i^2 for i in 1:5]
println()