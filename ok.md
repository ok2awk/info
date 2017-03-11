
# Lib 

Standard background stuff.


```c 

BEGIN { FS=OFS="," }

function helloWorld() {
  print "Hello world!"
}
function tests(fs,   a,f,i,n) {
   n = split(fs,a,",")
   for(i=1;i<=n;i++) {
     f = a[i]
     @f(f)
}}
function is(f,want,got,    pre) {
  pre = "#TEST:\t" f "\t" want "\t" got 
  if (want == got)
    print pre "\tPASSED" 
  else
    print pre "\tFAILED"
}
function has(lst,key) { 
  lst[key][1]
  delete lst[key][1] 
}
function have(lst,key,fun) { 
  has(lst,key)
  @fun(lst[key]) 
}
function haves(lst,key,fun,
               a,b,c,d,e) { 
  has(lst,key)
  if      (a=="") @fun(lst[key]) 
  else if (b=="") @fun(lst[key],a) 
  else if (c=="") @fun(lst[key],a,b) 
  else if (d=="") @fun(lst[key],a,b,c) 
  else if (e=="") @fun(lst[key],a,b,c,d) 
  else            @fun(lst[key],a,b,c,d,e) 
}
function lt(a,b) { return a < b }
function gt(a,b) { return a > b }

function empty(a) { split("",a,"") }
function push(i,v) { i[length(i) + 1] = v }

function isnum(x) { 
  return x=="" ? 0 : x == (0+strtonum(x)) 
}

function median(lst,
                n,p,q,lst1) {
  n = asort(lst,lst1)
  p = q = int(n/2+0.5)
  if (n <= 3) { 
    p = 1; q = n
  } else 
    if (!(n % 2) )
      q = p + 1;
  return p==q ? lst1[p] : (lst1[p]+lst1[q])/2
}
```


## o

Print nested array.


```c 

function o(l,prefix,order,
           indent,
           old,i) {
  if(! isarray(l)) {
    print "not array",prefix,l
    return 0}
  if(!order)
    for(i in l) { 
      if (isnum(i))
        order = "@ind_num_asc" 
      else 
        order = "@ind_str_asc"
      break
    }     
   old = PROCINFO["sorted_in"] 
   PROCINFO["sorted_in"]= order
   for(i in l) 
     if (isarray(l[i])) {
       print indent prefix "[" i "]"
       o(l[i],"",order, indent "|   ")
     } else
       print indent prefix "["i"] = (" l[i] ")"
   PROCINFO["sorted_in"]  = old 
}

```

