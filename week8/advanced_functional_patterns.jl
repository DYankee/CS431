#######################################
# Task 1: The Debugging Macro
#######################################

# We care about macro hygiene for this inspect macro because by default
# variables created inside of macros are scoped to avoid collisions with 
# variables in the callers code. This means we need to use esc() in the
# println function so it doesn't try to use local versions of variables 
# inside the expression.
macro inspect(expression)
    expression_str = string(expression)
    quote
        println("Execution expression: ", $expression_str)
        println($(esc(expression)))
    end
end

# Demo
println("Task 1: @inspect Macro")
@inspect 5 + 10
@inspect sqrt(144)
@inspect [i^2 for i in 1:5]
println()


#################################################
# Task 2: Handling "Nothing" (The Maybe Monad)
#################################################

# Bind function
function bind(value, f)
    value === nothing ? nothing : f(value)
end

# Sample database
users = Dict(
    "Paul" => Dict(
        :profile => Dict(:age => 83, :city => "Liverpool")
    ),
    "George" => Dict(
        :profile => Dict(:city => "Liverpool")
    ),
    "Ringo" => Dict(
        :profile => Dict(:age => 85, :city => "Liverpool")
    ),
    "John" => Dict(),
)

function find_age(name)
    get(users, name, nothing) |>
        u -> bind(u, u -> get(u, :profile, nothing)) |>
        p -> bind(p, p -> get(p, :age, nothing))
end

# Demo
println("Task 2: Handling Nothing (The maybe monad)")
for name in ["Paul", "George", "John", "Ringo"]
    age = find_age(name)
    if age === nothing
        println("$name -> Age not found!")
    else
        println("$name -> age = $age")
    end
end