# Write a single Julia script that performs the following steps strictly using functional pipelines (no loops allowed):
    # Filter: Remove all sensors that are NOT active.
    # Map: Convert the temperatures from Celsius to Fahrenheit ($F = C \times \frac{9}{5} + 32$).
    # Filter: Retain only records where the temperature is now above 70°F.
    # Reduce: Find the Average temperature of the remaining active, high-heat sensors.



# Sample Data Structure to start with:
using Statistics
data = [
  Dict(:id=>1, :temp=>20, :active=>true),
  Dict(:id=>2, :temp=>35, :active=>false),
  Dict(:id=>3, :temp=>25, :active=>true)
]

Average_temp = data |>
    active -> filter(d -> d[:active], active) |>
    fahrenheit -> map(t -> ((t * (9/5)) + 32), fahrenheit) |>
    hot -> filter(d -> d[:temp] > 70, hot) |>
    mean


println(Average_temp)