# WAF (Web Application Firewall) Parsing

A great example of when string parsing is a critical feature is when implementing a web application firewall or WAF. WAFs sit in front of a web enabled application to scan/monitor incoming http requests for malicious or unwanted connection attempts. They do this by inspecting the request at layer 7, and then accepting or rejecting requests based on a set of rules often called policies.

## The Choice

If I was implementing a WAF I think the best option would be to use REGEX. I chose Regex because cyber security is a constant battle often requiring new complex rules to handle threats. This is where Regex shines, instead of a series of functions to split and extract the necessary data from the request, we can instead use pattern matching to look for known exploits like SQL injection or cross-site scripting. Additionally because each rule is just a Regex, new ones can be added quickly to respond to active threats like DDOS.

## The Trade Off

The main trade offs with using Regex to check each request are the performance cost and readability. Take this Regex that caused the 2019 Cloudflare outage for example:

``` Regex

(?:(?:\"|'|\]|\}|\\|\d|(?:nan|infinity|true|false|null|undefined|symbol|math)|\`|\-|\+)+[)]*;?((?:\s|-|~|!|{}|\|\||\+)*.*(?:.*=.*))) 

```

Do you know what it does by just looking at it? I sure don't. If I wanted to modify this rule I would need to spend valuable time to breakdown and understand what the expression is doing before I started making changes.

Another potential issue with using Regex is the performance overhead of the Regex interpreter. Because Regex is essentially its own language built into and interpreted by other programming languages, There is a small but not insignificant overhead required to process a Regex versus using native string manipulation functions.

## The "ReDoS" Factor

Unfortunately we don't have to look far to find a real world example of how this approach can backfire. In 2019 Cloudflare, a cloud infrastructure company that provides WAF as part of their DNS service, experienced a global outage which affected a significant portion of all web traffic. This outage was caused by a rule added to the WAF cloudflare provides to their users. The rule included a poorly written Regex that would backtrack excessively overloading the CPUs used to serve HTTP traffic.

If you are interested in learning more about this outage, cloudflare has a great write up on their blog outlining exactly what went wrong, why, how they fixed, and the steps they took to prevent a similar issue in the future which can be found here: <https://blog.cloudflare.com/details-of-the-cloudflare-outage-on-july-2-2019/>.
