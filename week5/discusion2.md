### The elegance argument


A great example of when recursion provides an elegant solution to a problem is with Depth first Search. This is because DFS is an inherently recursive problem, requiring you to traverse each sub tree left to right bottom to top. Using recursion to implement a solution is so elegant because the stack call tracks your position in the tree without the need for extra variables. This makes the code more readable. Which is a valuable asset in today's world where the same piece of code might be worked on by dozens of developers and looked at by hundreds if not thousands.


### The stack risk


During a deep recursive function call, the call stack can overflow leading to the aptly named stack overflow error. This happens because each successive call to the function adds another frame to the call stack. These frames contain all of the data or "State" required for its associated function. Due to the finite nature of computers however, the stack has a limited space available to it for storing these frames. If a recursive call adds to many frames the stack will overflow and the program will crash. This can be a hard bug to catch because it only occurs in cases requiring deep recursion which might be rare.


### Tail Call Optimization


Tail call optimization or TCO is a method of optimization used by some languages to improve the performance of recursive functions. It does this by attempting to reuse the current frame for the subsequent function calls, drastically reducing performance and memory cost of subsequent calls. Even with TCO available, I believe you should still be careful when implementing recursive functions. Not all langues support TCO and even those that do still require the programmer to ensure the function is written in a way that TCO can be utilized.