
# Tips for Advanced AWK

After decades of coding in AWK, I've learned some useful
tips and tricks for advanced AWK programming.
This docment lists  those tips.

## Files

Most of my tricks can be summed up  in a few files:

- The `ok` pre-processor;
- Source code files `*.ok`, which `ok` pulls apart
  into Markdown `*.md` documentation files and
  `*.awk` executable AWK files;
- A library file `ok.ok` that stores some useful functions.
- A global variable `OK` that stores my globals, divided
  into keys that seperate data from different files.
- Executable and prioritized tests. For example, the file
  `xx.ok` can have test files `xx1.ok`, `xx2.ok`, `xx3.ok`
  and `xx4.ok`. The numbers 1,2,3,4 denote levels of testing
  (and calling level `n` tests also calls all test files
   _1,..n-1,n_.

### The `ok` Pre-processor

`ok` adds some useful extra functionality to AWK:
  
- A "dot" notation for nested array access;
- A test suite for that counts how often  the `wanted` and `got`;
  output for a test function is differnt;
- A lint function that hunts down rogue local variables;
- Multi-line strings;
- Shortcuts for working with Git.

### The `*.ok` Source Files

These files contain AWK code and Markdown, written in documentation.
For convenience, the first paragraph is excluded from the associated
`*.md` files:

- The first line  of that paragraph is a mode line that
  tells my favorite editor (vim) to handle this 
  file as a `*.awk` file.
- The next few lines hold some meta-information.

For example:

```c
 /* vim: set filetype=awk ts=2 sw=2 sts=2 et : */
OK.tips.author ="Tim Menzies"
OK.tips.email  ="tim@menzies.us"
OK.tips.version="0.1"
OK.tips.help   ="ok2awk.github.io/src/tips"
OK.tips.license="opensource.org/licenses/BSD-3-Clause"

```

### Test Files `*.ok`

A test file for `xx.ok` is called, say, `xx1.ok`. 
The test file starts by including the file it is testing,
as well as some test support functions from `ok.ok`:


```c
 /* vim: set filetype=awk ts=2 sw=2 sts=2 et : */
@include "ok" # imports testss and is
@include "xx"

```

Next, the `xx1.ok` test file contains test functions. Each
such test function is called a special way and presents
its results in a special way:

- Test functions are called with a context variable
  which, in the following, is called "`i`".
- Test functions present their results using the `is` function.
  The `is` function prints "PASSED" or "FAILED"  depending
  on whether or not the expected values are printed.

For example, suppose ``xx.ok` defines a function
that returns the `median` of a list.
That can be tested as follows. Note the final call
to `tests` that arranges calling multiple test functions,
each time
passing in the  name of the function
as the string`i`.

```c
function _ltgt(i) {
  #is(i, want, got)
  is(i,  1,    gt(10,8))
  is(i,  0,    gt(6,8))
  is(i,  1,    lt(5,10))
  is(i,  0,    lt(8,6))
}
function _med(i,    j,lst1,lst2,lst3,lst4) {
  for(j=1;j<=10;j++) lst1[j]=j; is(i, 5.5, median(lst1))
  for(j=1;j<=8;j++)  lst2[j]=j; is(i, 4.5, median(lst2))
  for(j=1;j<=3;j++)  lst3[j]=j; is(i,   2, median(lst3))
  for(j=1;j<=7;j++)  lst4[j]=j; is(i,   4, median(lst4))
}

BEGIN { tests("_ltgt,_med") }
```

To run all this, call `ok` on the test file; i.e.

    ./ok xx1

This outputs something like:

```
TEST:  _ltgt 1   1	  PASSED
TEST:  _ltgt	0   0	  PASSED
TEST:  _ltgt	1   1	  PASSED
TEST:  _ltgt	0   0	  PASSED
TEST:  _med  5.5	5.5	PASSED
TEST:  _med  4.5	4.5	PASSED
TEST:  _med  2   2   PASSED
TEST:  _med  4   4   PASSED
```

To run all level1 test files, call

     ./ok 1

This runs all the `*1.ok` files, then prints out the number
of `PASSED` or `FAILED` seen on output.


____

A lot of my tricks are embodied in `ok2awk`, a
pre-processor that adds some useful functionality
to raw AWK.

## Files

`Ok2awk` pulls apart `*.ok` files to generate:

- A documentation file `*.md`.  This documentation is pulled from  markdown
  comments found in multi-line strings that start and 
  end with triple double-quotes `===`.
- A code file *.awk`.  For these code files, `Ok` comments out those 
  multi-line strings (by prefixing all those lines with `#`).

```
           /---> xx.md  
xx.ok --->/
          \
           \---> xx.awk
```

The command line for calling `ok` on `xx.ok` is

``
./ok xx

```


As a side-effect of calling `ok`, any changes in the `*.ok`
files in the local directory are updated into
`*.md` and `*.awk` files.


## Configuration

Optionally, `ok` is configured by an `ok.rc` file that
defines where all these files are written to:

```
Awk=_var/awk # where to keep the generated awk files
Tmp=_var/tmp # where to write temporaroes
Docs=docs    # where to write the generated markdown files

MyName="'Tim Menzies'"
MyEmail="'tim@menzies.us'"

```

## Installation

A minimal install of `ok2awk` are the files `ok`, `ok.rc` and a library
of standard functions `ok.ok`.


```c 


 /* vim: set filetype=awk ts=2 sw=2 sts=2 et : */

```


# Tip04ok: Test Suite


```c 


@include "ok"
@include "xx"



A lot of my tricks are embodied in `ok2awk`, a
pre-processor that adds some useful functionality
to raw AWK.

## Files

`Ok2awk` pulls apart `*.ok` files to generate:

- A documentation file `*.md`.  This documentation is pulled from  markdown
  comments found in multi-line strings that start and 
  end with triple double-quotes `===`.
- A code file *.awk`.  For these code files, `Ok` comments out those 
  multi-line strings (by prefixing all those lines with `#`).

```
           /---> xx.md  
xx.ok --->/
          \
           \---> xx.awk
```

The command line for calling `ok` on `xx.ok` is

``
./ok xx

```

As a side-effect of calling `ok`, any changes in the `*.ok`
files in the local directory are updated into
`*.md` and `*.awk` files.


## Configuration

Optionally, `ok` is configured by an `ok.rc` file that
defines where all these files are written to:

```
Awk=_var/awk # where to keep the generated awk files
Tmp=_var/tmp # where to write temporaroes
Docs=docs    # where to write the generated markdown files

MyName="'Tim Menzies'"
MyEmail="'tim@menzies.us'"

```

## Installation

A minimal install of `ok2awk` are the files `ok`, `ok.rc` and a library
of standard functions `ok.ok`.

```



 /* vim: set filetype=awk ts=2 sw=2 sts=2 et : */


```c 

# Tip04: Use a Test Suite 

For all my files `xx.ok`, I add a test suite `xxok.ok`
whose first line is

```
@include "ok"
@include "xx"
```

Then there are test functions that accept
a context variable and call a test report 
function `is`. The syntax of that call is

```
is(context, want, got)
```

For example:

```c
function _ltgt(f) {
  is(f,1, gt(10,8))
  is(f,0, gt(6,8))
  is(f,1, lt(5,10))
  is(f,0, lt(8,6))
}
```

This is called with the `tests` function
that accepts a string of function names to call:

```
BEGIN {
  tests("_ltgt,_med")
}
```

When all this runs, it prints something like:

```
TEST:	_ltgt	1		1		PASSED
TEST:	_ltgt	0		0		PASSED
TEST:	_ltgt	1		1		PASSED
TEST:	_ltgt	0		0		PASSED
TEST:	_med	5.5	5.5	PASSED
TEST:	_med	4.5	4.5	PASSED
TEST:	_med	2		2		PASSED
TEST:	_med	4		4		PASSED
```

In this report, the last word will be `FAILED` if
the `want` and `got` values are different.

Note that the `ok` tool has a flag `tests` which:

- Runs all the test suite code; i.e. everything
in some `xxok.ok` file
- Then counts the number of `PASSED` and `FAILED`s.

```



 /* vim: set filetype=awk ts=2 sw=2 sts=2 et : */


```c 

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
```

BEGIN { 
  a.b.c=1
  a.b.d=2
  print(length(a.b) == 2)
}


```c 

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

```

 /* vim: set filetype=awk ts=2 sw=2 sts=2 et : */


```c 

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

```

 /* vim: set filetype=awk ts=2 sw=2 sts=2 et : */


```c 

# Tip21: Use one Constuctors  

One way to build data dictionaries

```c
function have(lst,key,fun)   { 
  lst[key][1];    
  delete lst[key][1]
  if (fun)
    @fun(lst[key])
}
function empty(a) { split("",a,"") }
```
function Symbol(i) {
}
```
```

