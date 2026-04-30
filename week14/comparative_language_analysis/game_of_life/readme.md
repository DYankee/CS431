# Game of Life

This project contains Conway's Game of Life implemented in 3 different languages, with the goal of comparing and comparing the performance.

The goal of this project was to compare and evaluate the performance / developer experience when working with different languages

## Running the simulation

### Lua

1. Ensure you have the latest lua interpreter installed
2. Navigate to the lua subfolder in the project
3. Run the command: ```lua gol.lua```

Optional args:

- seedPath(string) - Path to file containing a starting seed
- height(int) - height of the grid
- width(int) - width of the grid

``` example
lua gol ../seeds/tests/12x12testseed.txt 12 12
```

### Julia

1. Ensure you have the latest version of julia installed
2. Navigate to the julia subfolder in the project
3. Run the command: ```julia gol.jl```

Optional args:

- seedPath(string) - Path to file containing a starting seed
- height(int) - height of the grid
- width(int) - width of the grid

``` example
julia gol ../seeds/tests/12x12testseed.txt 12 12
```

### Haskell

1. Ensure you have the latest version of the haskell compiler installed
2. Navigate to the haskell subfolder in the project
3. Run the following command to compile the program: ```ghc -threaded -O2 gol.hs -o gol -rtsopts```
4. Then you can run the program with the command: ```./gol +RTS -T```

Optional args:

- seedPath(string) - Path to file containing a starting seed
- height(int) - height of the grid
- width(int) - width of the grid

``` example
./gol ../seeds/tests/12x12testseed.txt 12 12 +RTS -T
```

## Seeds

Included with the project are a collection of starting seeds to use for starting the simulation. These can be found in the folder called seeds. They are grouped into the following categories

### common

Popular seeds that demonstrate the game of life functionality with interesting designs.

1. Glider.txt
    - A simple small gilder

### Cool_seeds

Some cool seeds I found while trying out different patterns.

1. cool48x48.txt
    - Cool geometric pattern

### Tests

seeds used for testing the performance of different versions of the program.

1. 12x12testseed.txt
    - A diagonal shape with oscillating lines
2. 24x24testseed.txt
    - expanding and contracting oscillator
3. 48x48testseed.txt
    - A glider gun that shoots it self
