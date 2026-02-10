# Lab3 Reflection

## Question #1
### Explain why I used local variables
I used local variables in my code for the following reasons:
1. It helps prevent accidental overrides or naming conflicts in large programs. This happens because any variable declared without the local scope keyword are global, i.e. accessible from anywhere in the program. 
2. It also helps cut down on memory use by allowing them to be garbage collected when they go out of scope
3. Finally it helps improves performance by removing the need to look up values in the G table.

## Question 2
### Explain how the __index metamethod functioned in part 2
The __index metamethod was used to lookup a key that did not exist in the SpecialItem table. Since we used the setMetaTable function to set BaseTemplate's metatable as a fall back for SpecialItem, the lua interpreter will also check to see if the key exist in the __index. This allows us to create tables that inherit from other tables. 