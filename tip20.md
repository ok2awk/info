
# Tip20: Use one Global  

To build a library of reusable routines,
it is important that one routine does not
write over the memory of another.

So I have one global, called `OK`. The first thing I 
do is divide up that variable with some unique key (e.g.
the file name). 
This can be used for many things; e.g. 
initializing some config variables:

```
OK.tip20.seed   = 1
OK.tip20.name   = "tip20"
OK.tip20.version= "0.1"
OK.tip20.author = "Tim Menzies"
OK.tip20.email  = "tim@menzies.us"
OK.tip20.url    = "https://github.com/ok2awk/src"
OK.tip20.license= "https://opensource.org/licenses/BSD-3-Clause"
```


```c 
```

