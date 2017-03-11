
# Rules for Cleaner AWK

AWK is often used as a quick and dirty little language for writing quick
and dirty scripts-- tiny one-liners or little throwaway prototypes.
But that is not how I use the languge.  Instead, I treat AWK as a
meditation on the nature of programming:

- So much that we value in supposedly better, more complex languages, can be easily
  emulated in much simpler languages like AWK. 
- So much functionality that we value
  in more complex systems can be quickly implemented in a few lines of AWK. 

So AWK has become my bullsh*t detector about programming fads.  Are we
making programming needlessly more complex? Are there fundamentally
simpler alternatives-- some of which we have known about for decades
such as AWK?  You need to form your own answers to these questions. But
to help you think about it, I share my AWK code-- just to illustrate
how much can be done with so little.

Having said that, sometimes AWK code is _too_ dirty.  Where the language
fails is its packages-- there are none.  This is bad.  In other languages
(Python, PHP, Ruby, etc), programmers have ready access to large libraries
of code and package management systems that let them quickly find and
download whatever they want.

If the AWK community cannot clean up its act and solve the package
problem, it will never be taken seriously.  So in the following, I offer
my rules for writing and sharing AWK packages.  

Remember: its ok 2 awk!

# Managing AWK with `ok` 

Some of my rules and tricks need a little scripting support-- which I've
coded up in a Bash script called `ok` (described below).

## Installing `ok`

To install `ok`:
   
   mkdir ok2awk
   cd ok2awk
   git clone https://github.com/ok2ak.src
   chmod +x src/ok
   mkdir -p $HOME/.config/ok
   touch $HOME/.config/ok/config

## Configure `ok`

To configure `ok`, edit the file `$HOME/.config/ok/config`.
Mine looks like this:


```
MyName="'Tim Menzies'"
MyEmail="tim@menzies.us"
 web site for on-line doco:
MySite="ok2awk.github.io/info" 
 url for license:
MyLicense="opensource.org/licenses/BSD-3-Clause" 
 tell your  editor how to ediot your source: 
MyHeader="# /* vim: set filetype=sh ts=2 sw=2 sts=2  : */"

Awk="$HOME/opt/ok/awk" # where to keep the generated awk files
Lib="$HOME/opt/ok/lib" # where to keep the built awk apps
Tmp="$HOME/opt/ok/tmp" # where to write temporaroes
Src="${PWD}/../src"    # where to find the source files
Docs="${PWD}/../info"  # where to write Markdown files
```

## Testing `ok`

If all this works, then this code should print "Hello world"

     ./ok run 'helloWorld()'

# Rule: Code Needs Comments

My AWK makes extensive use of multi-line comments containing Markdown
notes, spread around the code (these comments start and end with `===`
at front of line).

The `ok` script parses
these files to generate the `*.md` files in `docs` and executable awk code
(with all the Markdown commented out) in `*.awk` files. So the workflow
looks like this:

```
                    /---> $Docs/xx.md  
xx.ok ---> ok ---> /
                   \
                    \---> $Awk/xx.awk
```

Note that the pathnames shown above can be changed in the `ok/config` file.
Note also that when AWK is called, it needs to be told about where to
find the `*.awk` files.  So when the `ok` took runs code, it uses the
following syntax (and `$Awk` and `$Tmp` are set from `ok.rc`):

```
AWKPATH="$Awk:$AWKPATH" gawk          \
     --dump-variables=$Tmp/awkvars.out \
     --profile=$Tmp/awkprof.out         \
     -f $1.awk
```

In the above, the `--dump-variables` and `--profile` flags are debugging
tools, explained below.

# Rule: Code Needs to be Shared

Code is useful to other people, but only if other people can access it.
To make my code publically accessible,  I run two repos:

- `ok2awk/src`  : Contains most of my system. I accept pull requests to this repo.
- `ok2awk/info` : Contains the generated Markdwon files. This one I manage
                  on my own, updating whenever `src` is updated. This one 
                  gets displayed as [ok2awk.github.io/src](https://ok2awk.github.io/src).

# Rule: Shared Code Needs Tests

One way groups can safely share code is to supply that code along with a test
suite. Using those tests, teams can update and improve code while, at the same
time, ensure that existing code still works.

So for every `xx.ok` file, I create a `xx1.ok` unit test file.  The
number ``1'' denotes test priority and the `ok` tool can be used
to call just the tests with a particular priority. My tests are usually
priority ``1'' but, if they are really slow to run, I give them a lower priority.

The header of a  test file contains:

      @include "xx" # i.e. load the code file
      @include "ok" # i.e. load the test suite functions from ok.ok

This is followed by test functions. Each of these functions accepts an
string that tells the function its own name; and prints out test results
using the `is` function:

       is(functionName, want, got)

For example, the following test function will print `PASSED` three
times, since all these `gots` (in argument 2) satisfies the `wants`
(in argument 3).

```
function _ltgt(i) {
  #is(i, want, got)
  is(i,  1,    gt(10,8))  # is 10 >  8
  is(i,  0,    gt(6,8))   # is  6 >  8
}
function _index(i) {
  #is(i, want, got)
  is(i,  3,    index("peanut", "an"))  
}
```

The last line of that file uses the `tests` function
to call the above test functions.

      BEGIN { tests("_ltgt,_index") }

When this runs, it prints PASSED or FAILED next to the name of the
test.  The `ok` tool can run the test files then count the number of
passes/fails. For example:

     ./ok 1    # runs tests priority 1
     ./ok 12   # runs tests priority 1 and 2
     ./ok 123  # runs tests priority 1 and 2 and 3
     ./ok 1234 # runs tests priority 1 and 2 and 3 and 4

# Rule: Standardized Source Code Conventions

Any text before the first comment is not added to the Markdown files. Thie
means my source files can contain obscure header information that won't
be displayed on the web.

My source file headers contain meta-information about the code:

```
 /* vim: set filetype=awk ts=2 sw=2 sts=2 et : */
OK.tips.author  = "'Tim Menzies'"
OK.tips.email   = "tim@menzies.us"
OK.tips.version = "0.1"
OK.tips.license = "'opensource.org/licenses/BSD-3-Clause"
OK.tips.more    = "ok2awk.github.io/src/rules"
```

The first line is a  mode line telling my favorite editor (VIM) to treat
this file as an AWK file.  To change that mode line, edit the config file
`ok.rc`.  mode

The `ok` tool has a function for initializing my kind of source code file.
A call to

   ./ok file mycode

will generate two files:

1. `mycode.ok` for the source code;
2. `mycode1.ok` for a test suite for the source code. The header of this file
   contains `@include "mycode"`;
 


# Rule: Add Nested Accessors

The `ok` script converts words seperated by "." into array references. So

     a.b["c"].d 
   
becomes

     a["b"]["c"]["d"]

# Rule: Take Care when Initializing Nested Arrays

AWK's default initialization method is to use empty strings as the
default value for new array entries.  To change that, such that nested
arrays can be initialized, I've written a function called `has `that:

- Initializes nested arrays by add a nested key;
- Then deletes that key;
- Thus leaving behind an empty list.

    function has(lst,key) { 
      lst[key][1]
      delete lst[key][1] 
    }

Nested intiailizations use a `fun` function that construct the recursive
contents.

    function have(lst,key,fun) { 
      has(lst,key)
      @fun(lst[key]) 
    }

The `haves` function handles nested constructors with variable number
of arguments:

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

The next rule shows examples of using `has, have, haves`.

# Rule: Use Constructors

When reading other people's code, it is useful to have a data definition
syntax. This lets newcomers get a quick overview of how your code works.

My data definition syntax for AWK uses nested lists and the `has` function
described above.  My data constructors start with an uppercase letter.
For example, the following `Person` has a year of birth (`yob`), a
`gender`, a `jobHistory` list (which is initially just an empty list)
and a `name`.


```c 
function Person(i, fname, lname, gender, yob) {
  i.yob   = yob
  i.gender= gender
  has(i,"jobHistory")
  haves(i,"name",    "Name",    fname, lname)
}
function Name(i,fname,lname) {
  i.name=fname
  i.last=lname
}
```


Calling `Person(i,"Omar","Khayyam", "m",1048)`
makes "`i`" 
# Rule: Don't Use /pattern/ {action}

This rule is probably not going to be very popular with traditional
AWKers but the more I code in AWK, the more I use functions rather than
the classic AWK `/pattern/ {action}' main top-level loop.

We could argue this, it you want (my email is tim@menzies.us), but it
axiomatic that if you want to build libraries of reusable sub-routines,
then those sub-routines cannot all assume that they control the main
top-level routine.

It is simple enough to replace `/pattern/ {action}` with the generic
readloop function shown in the next rule.

# Rule: Use Less  Globals

Most AWK scripts have lots of globals, which makes it hard to build
libraries.

So use less globals, ac

# Rule2: 

# Rule2: Deprecate /pattern/ {action}

Use more functions

# Rule3: Always build Test Suites


```c 


```

