# TP1

### 1.2 Simple expressions
 
- Operators can be used as functions by surrounding their symbol with parenthesis, whereas functions can be used as operators by surrounding them with backticks:

```
(+) 3 4 //operator as function

5 `mod` 2 //function as operator, mod is the integer division remainder!
```
- **Note:** sometimes we have to surround a negative number with parenthesis to avoid sysntatic errors. Exponentiation is right-associative. The div operations are executed from left to right.

### 1.3 Simple Functions

- Variables are a particular case of a function with no arguments. Valid function and argument names begin with lowercasse, ... but there are sinne keywords we can't use (like case, class,...)
Example:
```
-- funcX, which corresponds to the following equation:
 --funcX(a,b,c,x) = aT2 +bT +c, where T = cos(x)+sin(x)
 funcX :: Floating a => a-> a-> a-> a-> a
        a*t^2 + b*t + c
        where t = cos x + sin x
```

### 1.4 Conditional structures

- there are 4 main conditional structures: if-then-else, guards, pattern matching and case expressions.
Exemplo:

```
 five :: (Eq a, Num a) => a-> [Char]

-- version with if-then-else
 five n = if n == 5 then "five" else "not␣five"
 -- version with guards
 five’ n
 | n == 5 = "five"
 | otherwise = "not␣five"
 -- version with pattern matching
 five’’ 5 = "five"
 five’’ _ = "not␣five"
 -- version with case expression
 five’’’ n = case n of 5-> "five"
 _-> "not␣five" 

--
 
 min3 :: Ord a => a-> a-> a-> a -- min of 3 numbers

 -- version with if-then-else
 min3 x y z =
 if x < y && x < z
 then x
 else if y < z
 then y
 else z-- version with guards
 min3’ x y z
 | x < y && x < z = x
 | y < z = y
 | otherwise = 
```

### 2.1 Elementary types

- 'e :: T' notation is used to detone that expression e has type T.
- We can check the type of any expresion/function by using ':type' command.

    Bool (True, False)      //Two values: True and False

    Char                    //Single quotes

    String;

    Int (inteiros de precisão fixa, 64 bits);

    Integers (inteiros de precisão arbitrária, é até existir memória);

    Float (vírgula flutuante de precisão simples, 32 bits);

    Double (vírgula flutuante de precisão dupla, 64 bits);



### 2.2 Tuples

- a tuple is a sequence of elements with a fixed size. The elements do not have to be all of the same type. Denoted by '()'. 
- **!!!** Tuples with one element do not exist as they have the type of the actual element.
Some prelude functions for tuples:

```
fst -- returns the first element of a pair
snd -- returns the second elemnt of a pair
```

examples;

```
-- implement myFst, almost the same as fst

myFst :: (a,b) -> a
myFst (x,_) = x
```

### 2.3 Lists

- lists are a variable-sized sequence of elements of the same type
- they are homogeneous: all of the elements in a list **must** have the same type
- a list can have one element

- lists are represented as '[]'. A string is a particular case of list, [Char].

We can represent a list using:
    - [1,3,4,5,6]
    - 1:3:4:5:10:[]
    - [1,4..10]
    - using list comprehensions: [x | x <- [1..15], mod x 3 == 1] (see after)

- we use (++) to append two lists
- !! returns the n-th element of a list    


### 2.4 Typeclasses

- not all functions operate over a certain group of types. Haskell defines a typeclasses which group a set of types by a common property.
Exemplos:
```
- Num: numeric types
-Integral: integer types
-Fractional: floating-point types
-Floating: defines certain functions with irrational numbers
-RealFloat:another floating-point typeclass
-Eq: types for wich equality and inequality operators are defined
-Ord: types for which the comparison operators are defined
-Enum: types that can be enumerated
```

### 2.5 Type variables
When documenting the type of a variable, instead of making the commitment
of assigning a variable to a certain type, one could instead associate a variable to a
typeclass. This can be achieved using the notation:

 'e :: TC a =>a '

 This line denotes that e is of type a, which is an instance of typeclass TC.a is a type variable: e belongs to any data type a that is an instance of typeclass TC. The arrow '=>' denotes a *class constrain*.

Type variables can also be used without an associated type class. For example,
 the empty list [] can contain any type of variable, so one can document it using a
 type variable: [] :: [a] .


### 2.6 Functional types

- Functions also have a type. It is good practice to declare a function's type by writting it time right above its definition.

---

# TP2

### 1.5 Recursions
- As we know, in Haskell, there is not iteration, namely "for" and "while" cycles. To execute a fragment of code a certain number of times until a condition is met, one must use recursion, where a function’s expression contains a call to itself.
```
•
 Sample exercise IN-14
 Problem statement
 Implement the factorial function that computes the product of an integer n
 by all the numbers between 1 and n.
 factorial :: (Ord p, Num p) => p-> p
 Usage examples:
 *Main> factorial 6
 720
 Solution-- version with pattern matching and guards
 factorial 0 = 1
 factorial n
 | n > 0 = n * factorial(n-1)
 | n < 0 = error "negative␣argument"-- version with if-then-else
 factorial’ n =
 if n == 0 then 1
 else if n > 0
 then n * factorial’(n-1)
 else error "negative␣argument"
 In bothalternatives, the base case corresponds to when the argument is equal
 to 0. The recursive step is executed when the argument is positive.

```

### 3.1 Lists by range

- lists can be defined using ranges, with one or more formats. Hereare some examples:

```
 [1,2,3,4,5,6,7,8,9,10...]
 Prelude> [1..5]
 [1,2,3,4,5]
 Prelude> [1,3 .. 10]
 [1,3,5,7,9]
 Prelude> [1,0..]
 [1,0,-1,-2,-3,-4,-5,-6,-7,-8...]
 Prelude> [1,3 ..]
 [1,3,5,7,9,11,13,15,17,19...]
 Prelude> [’a’..]
 "abcdefghijklmnopqrstuvwxyz{|}~\DEL\128\129..."
 Prelude> [0.1, 0.2 .. 1]
 [0.1,0.2,0.30000000000000004,0.4,0.5,0.6,0.7000000000000001,0.8,0.9,1.0]
```
- Haskell is able to handle computations with infinite lists due to its *lazy evaluation* mechanic.

### 3.2 Lists by recursion

- same as above but now with recursion

### 3.3 Lists by comprehension

- usually has a structure: ```  [<pattern> | <generator 1>, <generator 2>, ..., <guard 1>, <guard 2> ...]``` where each generator has the format <patter> <- <list>. Each generator is responsible for iterating throught its list and producing a value for each element that is visited. Example:
```
 Prelude> [x^2 | x <- [1..10]]
 [1,4,9,16,25,36,49,64,81,100]
 Prelude> [x^2 | x <- [1..10], odd x]
 [1,9,25,49,81]
 Prelude> [x^2 | x <- [1..10], odd x, mod x 3 == 0]
 [9,81]
 The value on the left side of <- can be a "pattern", namely those used for lists
 and tuples. Examples:
 Prelude> [x | (x:_)<-[[1,2],[3,4]]]
 [1,3]
 Prelude> [(a,b) | (a,b) <- zip [1..3] [1..]]
 [(1,1),(2,2),(3,3)]
```

- using multiple generators works like with nessted loops: for each value of the leftmost generator, all combinations of values of the generator to the right are produced. Example:

```
Prelude> [(x,y) | x <-[1,2], y<-"ab"]
 [(1,’a’),(1,’b’),(2,’a’),(2,’b’)]
 Prelude> [(x,y) | y<-"ab", x <-[1,2]]
 [(1,’a’),(2,’a’),(1,’b’),(2,’b’)]
 Prelude> [[x,y] | x <-"ab", y<-x:"ab"]
 ["aa","aa","ab","bb","ba","bb"]
```

**Nota!!**: atenção! Os valores que vêm primeiramente repetidos são os leftmost

Examples:
```
• SampleexerciseLI-26
 Problemstatement
 a)Withoutusingthelistitself,definethefollowinglistbycomprehension.
 myList=[(0,5),(1,4),(2,3),(3,2),(4,1),(5,0)]
 b)ImplementfunListthatgeneralizesthelistabovewithrespecttoapositive
 integern.
 Usageexamples:
 *Main> myList
 [(0,5),(1,4),(2,3),(3,2),(4,1),(5,0)]
 *Main> funList 7
 [(0,7),(1,6),(2,5),(3,4),(4,3),(5,2),(6,1),(7,0)]
 Solution
 a)
 myList = [(x,5-x) | x <- [0..5]]
 Complexexpressions,suchastuples,canbeusedforthepatternsectionof
 alistcomprehension.
 b)
 funList :: Int-> [(Int,Int)]
 funList n = [(x,n-x) | x <- [0..n]]
```


--- 

# TP3

### 4.1 Fundamentals on higher-order functions

### 4.2 Lambdas

### 4.3 Currying

### 4.4 Common higher-order functions

### 4.5 Application and composition 

### 4.6 Folds 

### 4.7 Point-free style