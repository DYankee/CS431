#######################################
# Task 1: the The Fibonacci Duel
#######################################

function fib_iter(n)
    # Variables for tracking current and last value
    last = 0
    current = 1
    
    # Return 0 if user entered 1 
    if (n == 1)
        return current
    end

    # sum current and last value then set the last value to 
    # the current value and the current value to the sum
    for i in 2:n
        sum = last + current
        last = current
        current = sum
    end
    return current
end

function fib_recur(n) 
    # Base case if n is less then or equal to 1 return n
    if (n <= 1)
        return n
    end
    
    # Otherwise continue recursive loop
    return fib_recur(n - 1) + fib_recur(n - 2)
end

println("Task 1: iterative VS recursive fibonacci numbers")

# iterative fibonacci result and time cost
println("iterative 40th fibonacci number & time cost")
println("  ", fib_iter(40))
@time fib_iter(40)
# Recursive fibonacci result and time cost
println("Recursive 40th fibonacci number & time cost")
println("  ", fib_recur(40))
@time fib_recur(40)

#######################################
# Task 2: Tail call optimization (TCO)
#######################################
function fact(n)
    if n == 0 return 1 end
    return n*fact(n-1)
end

function fact_tail(n, acc=1)
    if n == 0 return acc end
    return fact_tail(n-1, n*acc)
end

n = 30
println("\n")
println("Task 2: recursive factorial TCO vs no TCO")
println("Recursive factorial with TCO time cost")
println("  ", fact_tail(n))
@time fact_tail(n)

println("Recursive factorial time cost")
println("  ", fact(n))
@time fact(n)


#######################################
# Task 3: Recursive Data Structures
#######################################
mutable struct Node
    next::Union{Node, Nothing}
    data::Int
end

# Function to create a list of size n storing its index as the data
function create_list(length::Int)
    length <= 0 && return nothing

    head = Node(nothing, 1)
    current = head
    for i in 2:length
        current.next = Node(nothing, i)
        current = current.next
    end

    return head
end

# Function to recursively sum the values of a list
function sum_list(node::Node, sum=0)
    sum += node.data
    if (isnothing(node.next))
        return sum
    end
    return sum_list(node.next, sum)
end

println("\n")
println("Task 3: recursive list summation")
println(sum_list(create_list(20)))