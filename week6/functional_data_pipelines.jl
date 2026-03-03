using Statistics

grades = [85, 92, 45, 60, 77, 30, 88, 55, 95]

average_curved_grade = grades |> 
    passing -> filter(x -> (x >= 60), passing) |>
    curved -> map(x -> x + 5, curved) |> mean

println("Average Curved grade: ", average_curved_grade)

# The major difference between map and map! is that map returns a new array with the modified data while map! modifies the original array.
# The reason we want to use map over map! in functional programming is rooted in one of the core principles of functional programming, Immutability. 
# We care about immutability for a couple of reasons. The first is because it makes it easier to reason about the code. 
# The only changes the developer needs to worry about are what happens in the function. in other words, no global state is modified or used in the function.
# This allows for the second main benefit, thread safety. Because pure functions are immutable, they also get the benefit of thread safety. Allowing them to 
# be shared across multiple threads without the need for synchronization.   