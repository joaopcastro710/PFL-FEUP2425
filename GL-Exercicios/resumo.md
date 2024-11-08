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

- When declaring a functional type, the '->' symbol is right-associative. Thus, indicating that a function f has the type a -> b -> c is equivalent to a -> (b -> c). As a result, parentheses must be used to indicate that an argument is a function. For example, if a function f has two arguments, the first of which being a function, and outputs another function, then its type declaration should be: ' f :: (a->b) -> c -> (d -> e) '

### 4.2 Lambdas

- lambdas (or anonymous functions) are used to define functions *on-the-fly*, that means: rather than writing a definition for a function that will be used once, the function can be written in an expression.
Exemplo:
```
 Prelude> (\x-> x + 1) 2
 3
 Prelude> (\(x:xs)-> x) [1..10]
 1
```

### 4.3 Currying

- Functions with multiple arguments can be considered as a series of functions which receive an argument and return a function which receives the second argument, and so on. This is known as currying.

- All functions with multiple arguments are thus considered to be curried. Since '->' is right-associative, we 'f::a->b->c' is equivelent to 'f::a->(b->c)', that is, a binary function returns an unary function.

- Arguments are passed to functions, one-by-one, by putting spaces between the
 function’s name and the name of each argument. This is known as application. If
 fewer arguments are passed to a function than what the function can accept, the
 function is known to be partially applied: rather than returning a value of its output
 type, it returns a function that receives the remainder of its inputs and only then
 returns its output.

- Example using 'map':

```
 (First alternative: definiting a function explicitly.)
 Prelude> let f l = drop 2 l
 Prelude> map f [[1,2,3],[4,5,6]]
 [[3],[6]]
 (Second alternative: using a lambda.)
 Prelude> map (\l-> drop 2 l) [[1,2,3],[4,5,6]]
 [[3],[6]]
 (Third alternative: using partial application.)
 Prelude> map (drop 2) [[1,2,3],[4,5,6]]
 [[3],[6]]
```

### 4.4 Common higher-order functions

- map: applies a function to each element of a list ``` map succ [1,2,3]->[2,3,4] ```

- filter: returns a sublist with the elements that satisfy a predicate: ```  filter odd [1..5]->[1,3,5] ```

- any: checks if at least one element of a list satisfy a predicate (T or F)

- all: checks if all the elements of a list satisfy a predicate

- takeWhile: returns the longest prefix of a list that satisfies a predicate

- dropWhile: returns the remainder of a list after calling takeWhile

- iterate: returns an infinite list where the i-th element is the application of a function f on a value x i times (starting at 0).

- zipWith: zips two list, then combines each pair using a binary function

- flip: swaps the order of the arguments in a binary functions


### 4.5 Application and composition 

- Function application consists in passing an argument to a function. By putting spaces between a function's name and arguments, the latter are passed one-by-one, from left-to-right. So by default it is ```f x y = (f x) y ```.

-  Function composition g . f is the operation of building a new function by
 passing the output of a function f as input to a function g: (g ◦ f)(x) = g(f(x)).

 Example:
 ```
  a) Implementap,whichworkssimilarlytoPrelude’sapplicationoperator
 ($).
 b)Implementcm,whichworkssimilarlytoPrelude’scompositionoperator
 (.).

  a)-- Alternative with infix definition
 ap :: (a-> b)-> a-> b
 f ‘ap‘ x = f x-- Alternative with prefix definition
 ap’ :: (a-> b)-> a-> b
 ap’ f x = f x
 Therightpartof $ isappliedtoafunctiononits left side, thus thefirst
 argumentofapmustbeafunction.
 Thefunctioncanbedefinedusinginfixnotation,butmustalwaysbeused
 usingthisnotation(evenifdefinedinprefixnotation).
 Thedefinitioncorrectlyemulatesthe $ sinceaprefixfunctionhasahigher
 precedence thananinfixoperation, asexplainedinthesolutionofexercise
 IN-1,inChapter1.
 b)-- Alternative with parentheses
 cm :: (b-> c)-> (a-> b)-> (a-> c)
 cm f g x = f(g x)-- Alternative with $
 cm’ :: (b-> c)-> (a-> b)-> (a-> c)
 cm’ f g x = f $ g x-- Alternative with a lambda
 cm’’ :: (b-> c)-> (a-> b)-> (a-> c)
 cm’’ f g = \x-> f(g x)
 ```

### 4.6 Folds 
- Folds are a family of higher order functions that process a data structure in a given order and return a value. Usually have two ingredients: a combining function and an accumulator.
- The two main functions are 'foldr' and 'foldl'.
- foldr performs right folds: it recursively combines the result of the list’s head and accumulator with the result of combining with the tail.
- foldl performs left folds: it recursively combines the result of combining all but the list’s last element and accumulator with the last element.

Example of how they differ:

```
foldr (-) 0 [1, 2, 3, 4, 5] = (1- (2- (3- (4- (5- 0))))) = 3
foldl (-) 0 [1, 2, 3, 4, 5] = (((((0- 1)- 2)- 3)- 4)- 5) = -15
```

---

# TP4

### 5.1 Creating type synonyms with the 'type' word

-type keyword can be used to define 'type synonyms'. These synonyms have the advantage of increasing the readibility. The general syntax is: ``` type <synonym name> <type variable 1> <type variable 2> ... = <expression> ```

- just like a type's name, the synonym's name must start with an upper letter.

Examples:
```
 type String = [Char]
 type Pair a = (a,a)
 type HashMap k v = [(k,v)]
```

### 5.2 Creating algebraic data types with the 'data' keyword

- if one wants to define a structure for a person with two strings: one with their name and another with their email, we can do:

```
type Person = (String, String)
```

### 5.3 Derived Types

- Consider the 'Shape' type defined in the previous sections. It is literally a shape. If we try to print a shape on the console or compare two shapes, an error is issued. To allow a shape to be printed and compared, one must define that it derives the typeclass Eq, sing the 'deriving' keyword. If a type T derives the typeclass TC, then T is an instance of TC.

### 5.4 Named Fields

- when defining a new type using 'data', the fields of a value can be given names using the record syntax.
-  If a class with named fields is an instance of Show, then they are
 printed in a different manner. Also, value of a type with named fields can be defined
 in an alternative way. Examples:
 ```
 Prelude> data Date = Date { day :: Int, month :: Int, year :: Int} deriving (
 → Show)
 Prelude> Date 18 6 2006
 Date {day = 18, month = 6, year = 2006}
 Prelude> Date {day = 18, year = 2006, month = 6}
 Date {day = 18, month = 6, year = 2006}

 ```

### 5.5 Modules

- a module is a set of related definitions, including those of functions, types and typeclasses. Using modules has the advantage of allowing for code to be reused in other projects that requiere the same functions, thus avoiding code duplication. Notable modules are Data.List,... to use them we just have to use 'import <module name>' 

### 5.7 Binary Search Trees

 Abinary search tree (BST) is a tree where all of the nodes have exactly two children
 and contain an element/key belonging to a type for which the < operator is defined
 (i.e. an object belonging to a type that is an instance of Ord). The two children of a
 node n, which are also BSTs, are known as the left and right children of n. Leaves
 do not contain anything.
 In this case study, it will be assumed that all the keys in a BST are unique.
 BSTs store their keys in an orderly fashion:
 • Theleft subtree of a node n only contains keys that are lesser than the key of n.
 • Theright subtree of a node n only contains keys that are greater than the key of n


### 6.1 Standart I/O