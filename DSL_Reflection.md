# DSL Reflection

## Ambiguity

In languages like LUA or Julia key words are baked into the language and require precise formatting and spelling. You cant just decide that you want to create a function by saying "do x on every item in y" you have to use the language keywords for creating a function, loop through each item in y, and then preform action x on it (possibly calling other functions which also need to be defined by the developer).  

Inform7 on the other hand, parses the text for information about the scene. Using verbs, nouns, adjectives, ect... Inform7 builds a model of the relationships between different objects, their locations, and actions that can be taken on/with them. This is a much easier way for the average person who has no development experience to start creating interactive programs. The english language can be ambiguous at times however requiring the user to be very specific with their phrasing so that the intended meaning is clear.  

## The DSL Trad-off

The main benefit of using a DSL can also be its biggest weakness. When using a DSL you trade the freedom of managing your own memory and data types for the convenience of built in logic designed specifically for the languages use case.  

In the case of inform7 this can be seen with the spacial mapping built into the language. Instead of needing to create a system for tracking rooms and their connections, Inform7 does this for us by allowing us to specify the adjacent rooms when we create it.

## Beyond the syntax

When writing my program one of the biggest pain points was formatting the text to be displayed. You have to be very carful with punctuation, forgetting a period or not remembering which lines need a semicolon can be a headache to debug when the parser gets confused and tries to attach part of one statement to another. Text display modifiers were also a pain to deal with. For my map action I needed to use a lot of text modifiers to format the display. Searching for a solution to this problem led me to the inform7 forum where I found a trick to create short hands for the different formatting options. I'm not a huge fan of how it works though and it feels more like a hack around the languages design instead of an elegant solution.
