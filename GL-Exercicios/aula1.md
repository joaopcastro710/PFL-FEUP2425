# Introduction


## Notes

- para fazer definições locas, usamos let ou where;
- atenção á identação !
- exemplo da função quicksort:
```
     qsort [] = []
     qsort (x:xs) = qsort xs1 ++ x ++ qsort xs2
        where xs1 = [x´| x' <- xs, x' <= x>]
              xs2 = [x' | x' <- xs, x' > x]
```

- um tipo é um nome para umacoleção de valores:

    Bool (True, False);
    Char;
    String;
    Int (inteiros de precisão fixa, 64 bits);
    Integers (inteiros de precisão arbitrária, é até existir memória);
    Float (vírgula flutuante de precisão simples, 32 bits);
    Double (vírgula flutuante de precisão dupla, 64 bits);

Não faz sentido somar  números e valores lógicos -> Em Haskell, estes erros são detetados classificando as expressões com o tipo do resultado.

- e :: T o resultado de 'e' será do tipo 'T';

**Notas Relevantes:**

 - Listas de tamanhos diferentes podem ter o mesmo tipo, mas tuplos de tamanhos diferentes têm sempre tipos diferentes;

 - A lista vazia [T] admite qualquer tipo, enquanto o tuplo vazio () apenas tem o tipo unitário ();

 - Não existem tuplos com apenas um elemento;

--- 

#### IN-1

- function application (writting a function name followed by its arguments) has higher precedence than any other operator
- exponentiation is right associative -> direita para esquerda
- Binaryfunctionsconvertedtooperatorsusingbackticksareleft-associative
 bydefinition.


#### IN-5
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

#### IN-13

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

---

## Fundamentals on types

### Tuples

> Sequence of elements with a fixed size and do not have to be all of the same type. Denoted by '()'


### Lists

> Sequência de tamanho variável de elementos dum mesmo tipo. []

- **Exemplos:**
```
-- Lists
[False, True, False] :: [Bool]
['f', 'E', 'u', 'P'] :: [Char] ou String 

-- Tuples
(3.14, 'P') :: [Double, Char]
(False,’b’,True) :: (Bool,Char,Bool)

-- Casos mistos
[[’a’], [’b’,’c’]] :: [[Char]]
(1,(’a’,2)) :: (Int,(Char,Int))
(1, [’a’,’b’]) :: (Int,[Char])

-- Funções
not :: Bool -> Bool
isDigit :: Char -> Bool
soma :: (Int, Int) -> Int ou então soma :: Int -> Int -> Int
contar :: Int -> [Int], com contar n = [1..n]
minuscula :: Char -> Bool
minuscula c = c>=’a’ && c<=’z’

```

### Currying

> É preferível usar Currying do que tuplos como argumentos. De acordo com as convenções sintáticas que prescindem de parêntises o processamento dos tipos é efetuado da direita para a esquerda e a compilação/aplicação da esquerda para a direita.

```
soma' :: (Int, Int) -> Int -- tuple based
soma' (x, y) = x + y

soma  :: Int -> Int -> Int -- currying
soma  x y = x + y
{-
    soma  :: Int -> (Int -> Int)
    (soma  x) y = x + y, retorna uma função f como resultado de (soma x) e depois computa (f y)
    function x y z = (((f x) y) z)
-}
```

**Importante:**
 'fromIntegral' converte qualquer tipo inteiro para qualquer outro tipo numérico.

 