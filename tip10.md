
# Tip10: Use dot notation 

AWK's associative arrays make it easy to build and
access complex nested structures. Also, due to their
uniformity, it is possible to write generics that
can run over all those lists.

`ok` adds a dot notation to AWK that makes it easy
to work with those nested arrays. Any word after a "`.`"
that does not start with a number gets converted
into  a quoted reference to an array:


```c
{ txt = gensub(/\.([a-zA-Z_])([a-zA-Z0-9_]*)/,
                 "[\"\\1\\2\"]",
                 "g",
                 $0) 
  gsub(/__/,".",txt)
  print txt
}
```

For example:

```c 
BEGIN { 
  a.b.c=1
  a.b.d=2
  print(length(a.b) == 2)
}

```


expands to

```c
BEGIN { 
  a["b"]["c"]=1
  a["b"]["d"]=2
  print(length(a["b"]) == 2)
}
```


## When you need to use "`.`"...

Aside:
If you need to use "`.`" between words (e.g. in some
file name), then use `__`.

For example, don't use

```
filename.csv
```

but instead
use

```
filename__csv
```


```c 
```

