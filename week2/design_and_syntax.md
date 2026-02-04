# Design and Syntax

Answers to the question for hands on 1

## Abstraction
### Which language above (A or B) provides a higher level of abstraction? Justify your answer using the term ”declarative” vs. ”imperative.”

In the first example with language A, the code is using a c++ style where the language doesn't make any assumption about what the programer is trying to do. Instead every action the computer takes must be clearly outlined. This causes the to code to have an imperative style where the programer not only tells the computer what to do but exactly how.

In the second example with language B, the code is using haskell style code where the language abstracts the behind the scenes implementation details of how the computer executes the given instruction. Opting instead to provide the programer with declarative keywords that instruct the compiler what the program should do but leaves the details of its implementation to the compiler or interpreter.

With these facts in mind I believe language B offers a higher level of abstraction. 

## Type Safety
### In your Week 1 environment setup, you installed Lua. Unlike the C++ prerequisite (CS 240), Lua is dynamically typed. What is one advantage and one danger of this design choice during the development of a large-scale system?

The main advantage of using a dynamically typed language is the lack of need for type conversions. The best example of this is when dealing with user input. Say you have a program where you ask the user for their name and age. In a dynamically typed language both of these values can be stored to a variable, concatenated together, or printed without needing to worry about converting them to the same datatype.

This however is also the biggest danger of using a dynamically typed language, we can never guarantee the shape of the data in a given variable. Lua variables for example can contain any value or even objects. This leads to the potential for more runtime errors where a function is passed a misshaped variable and throws an error or outright crashes the program. In a statically typed language many of these type of bugs are caught by the compiler making them far less likely to make it into production code. 

## The Right Tool
### Referencing the syllabus introduction, why might a developer choose a ”Scripting” approach for a data-parsing task rather than a ”Modular” approach like Modula-2?

A developer is more likely to choose a scripting language over a more modular approach to a data-parsing task because of the ease and speed of development. With a scripting language like lua, you dent need to worry about managing different data types and memory addresses leaving you to focus solely on the program logic. This is especially important for tasks like data-parsing that only need to be done once. Scripting languages also typically have better built in support for string manipulation and parsing instead of needing to write it yourself.

A more modular approach would only be worth the extra effort if the programer knows that the program will continue to be used and modified for new parsing tasks.