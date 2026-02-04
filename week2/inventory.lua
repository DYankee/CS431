-- Players inventory
PlayerInventory = {
	"Health Potion",
	"Shield",
	"Iron Sword",
}

-- Weight of items
itemWeights = {
	["Health Potion"] = 1,
	["Shield"] = 10,
	["Iron Sword"] = 15,
}

-- Function to get the total value of weights in the player inventory
function CalculateWeight()
	local totalWeight = 0
	for index, value in ipairs(PlayerInventory) do
		totalWeight = totalWeight + itemWeights[value]
	end
	return totalWeight
end

-- Function to print the players inventory
function displayInventory(inv)
	print("---- Player inventory ----")
	for index, value in ipairs(inv) do
		print(index .. ": " .. value)
	end
	print("--------------------------")
end

-- Print the inventory and its weight
displayInventory(PlayerInventory)
-- Calculate and print the weight of the inventory
print("Inventory Weight: " .. CalculateWeight())

-- Reflection Questions
-- 1. With lua's indices starting at 1, it is more easily read and understood by people
--    not familiar with programming. It makes it easier for non technical people to write
--    simple scripts to use in their daily work. The average sales person shouldn't need to
--    worry about off by 1 errors while trying to write a simple program to parse invoices
--    and compile some data.
--
-- 2. Lua's Table fulfills the role of both array and hashmap by allowing values to be
--    accused by index like an array; although the index starts at 1 instead of the
--    traditional 0. It can also be accessed by a key associated with a stored value
--    like a hash map. For example in the program we use both methods to access values
--    in a table. First in the CalculateWeight function we use the hash map access method
--    to find the weight of an item by its key; in this case the name of the item. Then in
--    the PrintInventory function, we use the index we get from the ipairs loop to access
--    each inventory item by its index.
