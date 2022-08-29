echo "Hello World" # where is the parenthesis?

# const (compile time) variables. 
const compileTimeString = "Hello World and I'm a const! "
echo compileTimeString

# let works like `final` in Dart
let a = 1
echo a
# var is the real variable. Not sure whether it will hoist or not. 
# (Don't think so)
var variable = 1234
variable = 4567
echo variable

# Can I do this? Yes! `if` control flow as expression
# The return type should be the same
let b = if true: "Hello" elif false: "World" else: "Not possible!" 
echo b

# The no parenthesis sytax reminds me of Elixr/Ruby

# basic pattern matching and `switch` as expression
# It supports range in `case`!
let c = case variable
  of 4567: "4567 is the variable"
  of 123..456: "123 to 456 is the variable"
  else: "Not possible!"
echo c

# no old bad C loop syntax
# seems `for` and only used in element access, which is the same as Zig
# If you want to do that use `while`! (I like Zig version)
for i in 0..3:
  echo i
# 0 1 2 wait...? 3
# It's inclusive!
for i in 3..<6:
  echo i
# 3 4 5 (not 6)

# b is string (char array)
for character in b:
  echo "b said: ", character # comma will not insert space between
# Well it looks like elixir now

for idx, character in "Nim":
  echo "at index ", idx, " is ", character

# "The when statement is useful for writing platform-specific code,
# similar to the #ifdef construct in the C programming language."
# We can ignore when now. It's less powerful Zig's comptime

# Now we begin to write type annotations first time (when declaring a function)

# Here is a stupid design...where is the result come from? How did I return it?
# (without `return`)
# The result variable is already implicitly declared at the start of the
# function
# not an arrow... The equal sign is the assignment operator is weird.
proc addOne(a: int): int = 
  result = a + 1

echo addOne(1) # 2

# A procedure that does not have any return statement and does not use the
# special result variable returns the value of its last expression. 
# This looks like Rust or JavaScript arrow function.
proc biggerThanTwoHundreds(a: int): string = 
  if a > 200:
    "Yes"
  else:
    "Nope"

# support default parameter is a big yes!
# It's too obvious! Just like Python
# Also the named parameter

# A classic swap function! Remember the swap function in C?
# Now you can say I want to pass by reference without the pointer!
# (It still involves the pointer definately)
proc customSwap(a, b: var int): void = 
  var temp = a
  a = b
  b = temp

var someNumber = 233
var anotherNumber = 666
customSwap(someNumber, anotherNumber)
echo "someNumber is ", someNumber # 666
echo "anotherNumber is ", anotherNumber # 233

# parameter is not mutable by default
# If you really want you can shadow the parameter

discard biggerThanTwoHundreds(201) # not possible without `discard`
# The same as _ = biggerThanTwoHundreds(201) in Zig
# or let _not_used = biggerThanTwoHundreds(201) in Rust

# function overloading is possible in Nim (I love it!)
# operator overloading is also possible in Nim (C++ and Python combined
# monstrosity)

# Now we have Monoid!
# https://nim-lang.org/docs/manual.html#types-distinct-type
type Sum = distinct int
type Product = distinct int

# Nim got template like traits. (More like concept for type constraint or a set
# of predefined functions?)

# Our user defined `<>` operator (We don't have this in C++ or Python)
proc `<>` (a: Sum, b: Sum): Sum = Sum(int(a) + int(b))
proc `<>` (a: Product, b: Product): Product = Product(int(a) * int(b))
proc `<>` (a: string, b: string): string = a & b
# $ is the show/stringify operator in Nim
proc `$` (a: Sum):string = $int(a)
proc `$` (a: Product):string = $int(a)

echo(Sum(1) <> Sum(2)) # 1 + 2
echo(Product(20) <> Product(30)) # 20 * 30
echo("Hello" <> " " <> "World") # HelloWorld

# If you want operator overloading, you have to get function overloading first
# Or duck typing like python? 

# Move on

# repr like dbg! in Rust. You don't have to implement `$` operator now.

# string is funcking mutable?

# array is fixed size (like C array)
# sequence is dynamic size (like C++ vector)
# Openarrays can only be used for parameters.
# We also have slice (pointer like or StringView)
# ^idx means counting from the end of the collection

# Nim uses procedural types to achieve functional programming techniques.
# First class function

# Go to part2
# We haven't touched Generics yet!

# "There is a syntactic sugar for calling routines: The syntax
# obj.methodName(args) can be used instead of methodName(obj, args). If there
# are no remaining arguments, the parentheses can be omitted"
#
# Nim promise procedure/function is the same thing as method in OO from sytnax
# Well... good job on this one. The auto complition of your editor is happy now!

# I'm not sure...duck typing?
# Procedures always use static dispatch. For dynamic dispatch replace the `proc`
# keyword by `method`

# The `!=`, `>`, `>=`, `in`, `notin`, `isnot` operators are in fact templates
# Template is more or less the same as inline function in C++
# A macro! I like it, just a bit.

# To pass a block of statements to a template, use untyped for the last parameter.
# Well, this shit is like Elixir's equivalent.

# Pragma. It's like annotation in Java? Haskell's language feature.
# https://downloads.haskell.org/~ghc/8.2.1/docs/html/users_guide/lang.html
# https://nim-lang.org/docs/manual.html#pragmas

# nimble is not good?
# could not import: SSL_get_peer_certificate
# Install libssl1.1
# https://packages.debian.org/bullseye/libssl1.1
# https://www.mail-archive.com/nim-general@lists.nim-lang.org/msg19329.html
