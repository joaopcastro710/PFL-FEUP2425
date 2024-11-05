-- Para fazer: 2.2 , 2.3, 2.4, 2.6, 2.7, 2.12, 2.15, 2.20, 2.21, 2.24

-- 2.2

intersperse :: a -> [a] -> [a]
intersperse _ []  = []
intersperse _ [x] = [x]
intersperse sep (x:xs) = x : sep : intersperse sep xs

-- 2.3

mdc :: Integer -> Integer -> Integer
mdc a 0 = a 
mdc a b = mdc b ( mod a b)

-- 2.4 

insert :: Ord a => a -> [a] -> [a]
insert x [] =[x]
insert x (y:ys)
    | x <= y = x : y :ys
    | otherwise = y : insert x ys

isort :: Ord a => [a] -> [a] 
isort [] = [] --empty
isort (x:xs) = insert x (isort xs)
 
-- 2.6

sumOfSquares :: Integer
sumOfSquares = sum [x^2| x <- [1..100]]

-- 2.7

-- a 
aprox :: Int -> Double
aprox n = 4 * sum [((-1)^k)/fromIntegral(2k+1) | k <- [0 .. n-1]]

--(b)
aprox' :: Int -> Double
aprox' n = sqrt (12 * sum [((-1) ^ k) / fromIntegral ((k + 1) ^ 2) | k <- [0..n-1]])

-- 2.12
divisores :: Integer -> [Integer]
divisores n = [x | x <- [1..n], n `mod` x == 0]


primo :: Integer -> Bool
primo n = divisores (fromIntegral n) == [1,n]

-----------------------------------------------

-- 2.15

import Data.Char (chr, ord)

-- Converte letras em inteiros 0..25 e vice-versa
letraInt :: Char -> Int
letraInt c = ord c - ord 'A'

intLetra :: Int -> Char
intLetra n = chr (n + ord 'A')

maiúscula :: Char -> Bool
maiúscula x = x >= 'A' && x <= 'Z'

-- Efetuar um deslocamento de k posições
desloca :: Int -> Char -> Char
desloca k x | maiúscula x = intLetra ((letraInt x + k) `mod` 26)
            | otherwise = x

-- Repetir o deslocamento para toda a cadeia de caracteres
cifrar :: Int -> String -> String
cifrar k xs = [desloca k x | x <- xs]

----------------------------------------------------------

--2.20
transpose :: [[a]] -> [[a]]
transpose [] = []                           --when empty
transpose ([]:xs) = transpose xs            --when the 1st element is empty, we remove that and keep the process
transpose x = (map head x) : transpose (map, tail x)


-------------------------------------------------------

--2.21

--aux
algarismosRev :: Int -> [Int]
algarismosRev 0 = []
algarismosRev n = (n `mod` 10) : algarismosRev (n `div` 10)


algarismos :: Int -> [Int]
algarismos 0 = [0]  -- Caso especial para o número 0
algarismos n = reverse (algarismosRev n)