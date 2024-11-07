-- IN-3
{-
 a) (3-(-2))+1
 b) (4/(-2))-3*6
 c) (-)23*6 -> (2-3)*6
 d) (100‘div‘4)‘div‘3   
 e) 100‘div‘ (div 43)
 f) (+)12+3*4
 g) (+)(5‘mod‘2+2)(mod 52)

 -}

-- IN-6
-- a
half :: Fractional a => a -> a
half x = x/2

-- b
xor :: Bool -> Bool -> Bool
xor a b = (a && (not b)) || ((not a) && b)

-- c

cbrt :: Floating a => a-> a
cbrt x = x**(1/3)

-- d

heron :: Floating a => a-> a-> a-> a
heron a b c =sqrt (s*(s-a)*(s-b)*(s-c))
             where s = (a+b+c)/2



-- IN-7

isTriangular :: (Ord a, Num a) => a-> a-> a-> Bool
isTriangular a b c =
            (a + b <= c) && (a + c <= b) && (b + c <= a)


isPythagorean :: (Num a, Eq a) => a-> a-> a-> Bool
isPythagorean a b c =
     (a^2 + b^2 == c^2) || (a^2 + c^2 == b^2) || (b^2 + c^2 == a^2)


-- IN-13

f :: (Ord a, Num a) => a -> Int
f x
    | x > 0 = 1
    | x < 0 = -1
    | x == 0 = 0

    -- a - function that returns 1 if the number is positive, -1 if negative or 0 if null (0)

-- b
ff :: (Ord a, Num a, Integral b) => a-> b
ff 0 = 0
ff x = if x > 0 then 1 else-1


-- FT-3
mySwap :: (b, a)-> (a, b)
mySwap (x,y) = (y,x)

-- FT-4
--a 

distance2 :: Floating a => (a, a)-> (a, a)-> a
distance2 (x1,y1) (x2,y2) = sqrt ((x1-x2)^2 + (y1-y1)^2)

distanceInf :: (Num a, Ord a) => (a, a)-> (a, a)-> a
distanceInf (x1,y1) (x2,y2) = max (abs(x1-x2)) (abs(y1-y2))

-- FT-9
{-
 a) reverse [] - []
 b) [[1,2]]++[[]]++[[3],[4,5]] [[1,2], [], ...]
 c) [1,2]:[]:[3]:[[4,5]] 
 d) ([1,2]:[]:[3]:[[4,5]])!! 3 [4,5]
 e) length ([]:[]:[]:[]) -3
 f) take 2([1,2]:[3,4,5]:[6,7]:[8]) -- error, the expression is invalid
 g) take2([1,2]:[3,4,5]:[6,7]:[]) -- [[1,2][3,4,5]]
 h) []:[]:[]++[]:[]
 i) "abc":[[]]++"dce":[]
 j) tail ([1]:[]:[2]:[3]:[])
 k) [[1,2,3,4],[5,6,7,8],[9,10,11,12]]!!2!!3
 l) [5,6,7,8]‘elem‘[[1,2,3,4],[5,6,7,8],[9,10,11,12]]

-}
-- FT-10
{-
--a : function f returns a pair with the third element of the input list l and the sublist of l starting at the fourth element

--b :
ff :: [a]-> (a,[a])
ff l = (l !! 2, drop 3 l)

 f :: [a]-> (a,[a])
 f (_:_:x:y) = (x,y)

-}


-- FT-21
{-
 a) Write a valid type declaration for the following expressions without using
 type variables.
 i) zip [1,2] "abc"
 ii) [[1],[2]]
 iii) [succ ’a’]
 iv) [1,2,3,4,5.5]
 v) [1,2] == [1,2]
 vi) zip (zip "abc""abc")"abc"
 b) Write the most general type declaration for the previous expressions.

 a)
 i) zip [1,2] "abc":: [(Integer, Char)]
 ii) [[1],[2]] :: [[Int]]
 iii) [succ ’a’] :: [Char]
 iv) [1,2,3,4,5.5] :: [Float]
 v) [1,2] == [1,2] :: Bool
 vi) zip (zip "abc""abc")"abc":: [((Char,Char),Char)]
 b)
 i) zip [1,2] "abc":: Num a =>[(a, Char)]
 ii) [[1],[2]] :: Num a =>[[a]]
 iii) [succ ’a’] :: [Char]
 iv) [1,2,3,4,5.5] :: Fractional a =>[a]
 v) [1,2] == [1,2] :: Bool
 vi) zip (zip "abc""abc")"abc":: [((Char,Char),Char)]
-}


-- TP2

-- IN-17

fib :: (Num a, Ord a, Num p) => a-> p
fib 0 = 0
fib 1 = 1
fib n 
    | n > 0 = fib(n-2) + fib(n-1)
    | otherwise = error "negative"

-- IN-18

ackermann :: (Num a, Ord a, Num t, Ord t) => a-> t-> t
ackermann 0 n = n+1
ackermann m 0 = ackermann (m-1) 1
ackermann m n 
    | (m>0) && (n>0) = ackermann (m-1) (ackermann m (n-1))
    | otherwise = error "erro"



-- FT-14
scalarProduct :: Num a => [a]-> [a]-> a
scalarProduct [] [] = 0
scalarProduct (x:xs) (y:ys) = (x*y) + (scalarProduct xs ys)


-- LI-13

mySplitAt :: Int -> [a] -> ([a], [a])
mySplitAt 0 1 = ([], 1)
mySplitAt _ [] = ([], [])
mySplitAt n (x:xs)
    | n > 0 = (let (a,b) = mySplitAt (n-1) xs in (x:a,b))
    | otherwise = error "error"


-- LI-14

myGroup :: Eq a => [a] -> [[a]]
myGroup [] = []
myGroup [x] = [[x]]
myGroup (x:y:xs)
    | x == y = (x:g):gs
    | otherwise = [x]:g:gs
    where (g:gs) = myGroup(y:xs)



