using Statistics



# Sample Data Structure to start with:
data = [
  Dict(:id=>1, :temp=>20, :active=>true),
  Dict(:id=>2, :temp=>35, :active=>false),
  Dict(:id=>3, :temp=>23, :active=>true),
  Dict(:id=>4, :temp=>27, :active=>false),
  Dict(:id=>5, :temp=>32, :active=>true),
  Dict(:id=>6, :temp=>34, :active=>true),
  Dict(:id=>7, :temp=>25, :active=>false)
]

Average_temp = data |>
    active -> filter(d -> d[:active], active) |>
    fahrenheit -> map(d -> ((d[:temp] * (9/5)) + 32), fahrenheit) |>
    hot -> filter(d -> d > 70, hot) |>
    mean

println("Average Temperature of active sensors above 70°F: ", Average_temp)

# This code is safer than the imperative version because no data is mutated. 
# In other words at no stage in the pipeline is any of the original data modified. 
# Instead the data is copied modified and placed into a new container which is then passed to the next step.
# This allows for easy parallelization when additional threads are available. 