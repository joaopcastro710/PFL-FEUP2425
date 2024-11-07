import Data.List-- splitAt-- Quick sort version

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
mySplitAt 0 l = ([], l)
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


-- LI-15 returns the list of prefixes of its argument list

-- a 
myInits :: [a] -> [[a]]
myInits [] = [[]]
myInits (x:xs) = [] : (addHeadToAll x (myInits xs))

addHeadToAll :: a -> [[a]] -> [[a]]
addHeadToAll _ [] = []
addHeadToAll h (l:ls) = (h:l):(addHeadToAll h ls)


-- LI-16

-- a 

myZip :: [a] -> [b] -> [(a,b)]
myZip [] _ = []
myZip _ [] = []
myZip (x:xs) (y:ys) = (x,y):(myZip xs ys)

-- b 

myZip3 :: [a] -> [b] -> [c] -> [(a,b,c)]
myZip3 [] _ _ = []
myZip3 _ [] _ = []
myZip3 _ _ [] = []
myZip3 (x:xs) (y:ys) (z:zs) = (x, y, z):(myZip3 xs ys zs)

--LI-17

differentFromNext :: Eq a => [a] -> [a]
differentFromNext [] = []
differentFromNext [x] = [x]
differentFromNext (x:y:xs)
        |(x==y) = differentFromNext(y:xs)
        | otherwise = x:(differentFromNext(y:xs))


-- LI-18

myTranspose :: [[a]] -> [[a]]
myTranspose [] = []
myTranspose m = hs:(myTranspose ts)
    where (hs, ts) = splitHeadsTails m 

splitHeadsTails :: [[a]] -> ([a], [[a]])
splitHeadsTails [] = ([], [])
splitHeadsTails (ys:xs) = 
    case ys of  [] -> (hs, ts) -- se estiver vazio, continuamos com hs e ts
                [z] -> (z:hs, ts)
                (z:zs) -> (z:hs, zs:ts)
    where (hs, ts) = splitHeadsTails xs   

-- LI-20

mySubsequence :: [a] -> [[a]]
mySubsequence [] = [[]]
mySubsequence (x:xs) = addOrNotToHead x (mySubsequence xs)

addOrNotToHead :: a -> [[a]] -> [[a]]
addOrNotToHead h [] = []
addOrNotToHead h (l:ls) = l:(h:l):(addOrNotToHead h ls)

-- the auxiliary funcition receives an element h and list l, and creates
-- a new list where two elements are created for each non-empty suffix s of l 


-- LI-29

{-
 a) [mod x 7 | x <- ([1..5] ++ [16..23])] -> fica [1,2,3,4,5,16,...23] e cada um a dividir por 7. A lista fica com o resto
 b) [x ++ "␣the␣"++ y | x <- ["buy","loan"], y <- ["car","house"]]
 c) [x | x <-[-5..5], abs(x^3)<= 20]
 d) take 10 [-x | x <- cycle [4,7,8]]
 e) take 10 [ 5*x*y | x<-[1..], y <-[1..]]
 f) [(a+1,b)| (a,b)<- zip [1..3] [10..]]
 g) [[x | (x,y)<- zip xs (tail xs), x > y] | xs <- [[3,4,3],[4,3,3],[4,2,3,1],[5,4,1],[4,3,2,1]]]
-}

-- LI-31

differentFromNext2 :: Eq a => [a] -> [a]
differentFromNext2 l = [x | (x,y) <- zip l (tail l), x /= y] --tail tira tudo menos o 1

-- LI-32

conseqPairs :: Eq a => [a] -> [(a, a)]
conseqPairs l = [(a,b) | (a,b) <- zip l (tail l)]

-- LI-33

myZip31 :: [a] -> [b] -> [c] -> [(a,b,c)]
myZip31 x y z = [(a,b,c) | (a,(b,c)) <- zip x (zip y z)]

-- LI-35

checkMod3ThenOdd :: Integral a => [a] -> Bool
checkMod3ThenOdd l = and[mod x 2 == 1 | x <- l, mod x 3 == 0] -- se é divisor de 3 e impar

-- LI-36

repearNTimes :: Integral a => a -> [b] -> [b]
repearNTimes n l = [x |x <- l, _ <- [1..n] ]

-- HO-3

applyN :: (Integral n) => (a->a) -> n -> a -> a 
applyN _ 0 x = x
applyN f n x 
    | (n > 0) = f (applyN f (n-1) x)
    | otherwise = error "error"

cipher :: (Integral n) => n -> [Char] -> [Char]
cipher _ [] = []
cipher n (x:xs) = (applyN nextChar n x):(cipher n xs)

nextChar :: Char -> Char
nextChar 'z' = 'a'
nextChar c = succ c


-- HO-7

sortByCond :: Ord a => [a]-> (a-> a-> Bool)-> [a]
sortByCond [] _ = []
sortByCond (x:xs) cmp =
    (sortByCond lower cmp) ++ [x] ++ (sortByCond upper cmp)
    where (lower, upper) = myPartition x xs cmp

myPartition :: Ord a => a-> [a]-> (a-> a-> Bool)-> ([a], [a])
myPartition _ [] _ = ([],[])
myPartition v (x:xs) cmp
    | cmp x v = (x:a,b)
    | otherwise = (a,x:b)
    where (a,b) = myPartition v xs cmp


-- HO-10

myUncurry :: (a -> b -> c) -> (a,b) -> c
myUncurry f (a,b) = f a b 

myUncurry' :: (a -> b -> c) -> (a, b) -> c
myUncurry' f = \(a,b) -> f a b      --with binary lambda function

myUncurry'' :: (a -> b -> c) -> (a, b) -> c
myUncurry'' = \f (a,b) -> f a b     -- ternary lambda function


-- HO-14

orderedTriples :: Ord a => [(a,a,a)] -> [(a,a,a)]
orderedTriples = filter (\(a,b,c) -> (a <= b) && (b <= c))

-- HO-15

myMap :: (a->b) -> [a] -> [b]   --recebe uma função e depois uma lista e retorna uma lista
myMap f l = [f x | x <- l]

-- HO-16

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter f l = [x | x <- l, f x]

-- HO-17

myTakeWhile :: (a-> Bool) -> [a] -> [a]
myTakeWhile f [] = []
myTakeWhile f (x:xs)
    | f x = x : (myTakeWhile f xs)
    | otherwise = []


myDropWhile :: (a -> Bool) -> [a] -> [a]
myDropWhile f [] = []
myDropWhile f (x:xs)
    | f x = myDropWhile f xs
    | otherwise = x:xs


-- HO-18
{-
 Consider themyAll function,which, similarly toPrelude’s any, givena
 predicatepandalistl,checksifalltheelementsoflsatisfyp.
 a)ImplementmyAllusingrecursion(andwithoutusinguserhigher-order
 functions).
 b)ImplementmyAllusingalistcomprehensionandthe‘and’function,and
 withoutusingrecursion.
 c)ImplementmyAllusingmapandwithoutusingrecursionorlistcompre
hensions.
 d) ImplementmyAll usinganyandwithout usingmap, recursionor list
 comprehensions.
e)ImplementmyAllusingotherhigher-orderfunctions(otherthanmap,any
 andall)andwithoutusingrecursionorlistcomprehensions.
-}
{-
 --a)
 myAll :: (a-> Bool)-> [a]-> Bool
 myAll _ [] = True
 myAll p (x:xs) = (p x) && myAll p xs
 --b)
 myAll’ :: (a-> Bool)-> [a]-> Bool
 myAll’ p l = and [p x | x <- l]
 --c)-- Version with explicit list argument
 myAll’’ :: (a-> Bool)-> [a]-> Bool
 myAll’’ p l = and (map p l)-- Version without explicit list argument and composition
 myAll’’’ :: (a-> Bool)-> [a]-> Bool
 myAll’’’ p = and . (map p)
 --d)
 myAll’’’’ :: (a-> Bool)-> [a]-> Bool
 myAll’’’’ p l = not (any (not . p) l)
 --e)-- Version with filter
 myAll’’’’’ :: (a-> Bool)-> [a]-> Bool
 myAll’’’’’ p l = null (filter (not . p) l)-- Version with takeWhile
 myAll’’’’’’ :: (a-> Bool)-> [a]-> Bool
 myAll’’’’’’ p l = length l == length (takeWhile p l)
-}


-- HO-32
-- using fold
myMap2 :: (a-> b) -> [a] -> [b]
myMap2  f l = foldr(\x acc -> (f x):acc) [] l

-- HO-33

largePairs :: (Ord a, Num a) => a -> [(a,a)] -> [(a,a)]
largePairs max ts = foldr(\(x,y) acc -> if (x+y > max) then (x,y):acc else acc) [] ts


-- HO-35

separateSingleDigits :: (Integral a) => [a] -> ([a], [a])
separateSingleDigits l = foldr(\x (ys, ns) -> if (x >= 0 && x <= 9) then (x:ys, ns) else (ys,x:ns)) ([], []) l

-- HO-37

myFoldr :: (a -> b -> b) -> b -> b -> [a] -> b
myFoldr _ acc [] = acc
myFoldr f acc (x:xs) = f x (myFoldr f acc xs)

myFoldl :: (b-> a-> b)-> b-> [a]-> b
myFoldl _ acc [] = acc
myFoldl f acc (x:xs) = myFoldl f (f acc x) xs

