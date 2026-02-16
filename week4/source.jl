####################
# Type definitions
####################
abstract type GeometricShape end

struct Rectangle <: GeometricShape 
    width::Float64
    height::Float64
end

struct Triangle <: GeometricShape
    width::Float64
    height::Float64
end

struct Circle <: GeometricShape 
    radius::Float64
end

########################################
# Collision detection functions
########################################
# any Shape + any Shape
function describe_collision(shape1::GeometricShape, shape2::GeometricShape)
    println("Two shapes just collided!")
end
# Circle + Circle
function describe_collision(shape1::Circle, shape2::Circle)
    println("Two circles just collided!")
end
# Circle + Rectangle 
function describe_collision(shape1::Circle, shape2::Rectangle)
    println("A Circle and a Rectangle just collided!")
end
# Circle + Triangle
function describe_collision(shape1::Circle, shape2::Triangle)
    println("A circle and a Triangle just collided!")
end
# Triangle + Rectangle
function describe_collision(shape1::Triangle, shape2::Rectangle)
    println("A Triangle and a Rectangle just collided!")
end

########################################
# Area Calculation functions
########################################

# Rectangle
function area(shape::Rectangle)
    shape.width * shape.height
end
# Triangle
function area(shape::Triangle)
    (shape.height * shape.width) / 2
end
# Circle
function area(shape::Circle)
    pi * (shape.radius * shape.radius)
end


####################
# Driver code
####################

# Variable definitions
shape1 = Rectangle(42, 42)
shape2 = Triangle(5.6, 12)
shape3 = Circle(3.14)

# Multiple Dispatch Example
println("Multiple dispatch example: ")
describe_collision(shape2, shape2)
describe_collision(shape3, shape3)
describe_collision(shape3, shape1)
describe_collision(shape3, shape2)
describe_collision(shape2, shape1)

# Extensibility demonstration
println("Extensibility example: ")
println("Shape 1($(typeof(shape1))) has an area of: $(area(shape1))") 
println("Shape 2($(typeof(shape2))) has an area of: $(area(shape2))") 
println("Shape 3($(typeof(shape3))) has an area of: $(area(shape3))") 