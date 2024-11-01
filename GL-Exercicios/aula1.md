# Introduction

### IN-1

- function application (writting a function name followed by its arguments) has higher precedence than any other operator
- exponentiation is right associative -> direita para esquerda
- Binaryfunctionsconvertedtooperatorsusingbackticksareleft-associative
 bydefinition.


### IN-5
```
funcX, which corresponds to the following equation:

    funcX(a,b,c,x) = aT2 +bT +c, where T = cos(x)+sin(x)

    funcX :: Floating a => a-> a-> a-> a-> a
```
```
funcX a b c x =

    let t = cos x + sin x in

    a*t^2 + b*t + c-- version with where

    funcX’ a b c x =

    a*t^2 + b*t + c

    where t = cos x + sin x
```

### IN-13

 Consider the definition of function f below:

 ```
 f :: (Ord a, Num a, Integral b) => a-> b
 f x
    | x > 0 = 1
    | x < 0 =-1
    | x == 0 = 0
 ```

    (a) Explain concisely what function f computes.
    (b) Implement function f without using guards and using at most one if-then else expression.


 a)Function f computes the sign of a number x, and returns 1,-1 or 0, respectively,if x is positive,negative or null.

 b)
 ```
 f’ :: (Ord a, Num a, Integral b) => a-> b
 f’ 0 = 0
 f’ x = if x > 0 then 1 else-1

 ```
 A pattern is used to cover the case where x is equal to 0.This avoids the need to use a nested if-then-else expression in the second definition.



# Fundamentals on types

## Tuples

> Sequence of elements with a fixed size and do not have to be all of the same type. Denoted by '()'
(exercicio simples de tuplos)


## Lists

> Sequence of elements of the same type. Denoted by '[]'