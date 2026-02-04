print("--- Part 1: Inventory Setup ---")
-- Inventory Table
local Inventory = {
    {
        name = "Processor",
        price = 300,
        stock = 5
    },
    "RAM",
    "Motherboard"
}
print("Item 1 is: " .. Inventory[1].name .. "\n")


print("--- Part 2: Metatable Inheritance ---")
-- Define BaseTemplate
local BaseTemplate = {
    identify = function ()
        print("Generic System Component \n")
    end
}
-- Define SpecialItem and set its metatable to SpecialItems
local SpecialItem = {}
setmetatable(SpecialItem, {__index = BaseTemplate})
io.write("Identification: ")
SpecialItem.identify()


print("--- Part 3: Closures ---")
local function createTaxCalculator(rate)
    return function(price)
       return price + price * (rate / 100)
    end
end
-- Create tax calculators
local nyTax = createTaxCalculator(8)
local vaTax = createTaxCalculator(5)
print("Price in NY (8%): ", nyTax(100) .. "\n")


print("--- Part 4: Integration Loop ---")
for index,value in pairs(Inventory) do
    if (type(value) == "table") then
        print("Processing Processor...")
        print("Base Price: " .. value.price)
        print("Final Price with NY Tax: " .. nyTax(value.price) .. "\n")
    else
        print("Skipping simple entry: " .. value)
    end

end