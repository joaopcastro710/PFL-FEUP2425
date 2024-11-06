-------------------------------------------------------
--3.1
-- filter para selecionar os elementos de xs que satisfazem o p
-- map para aplicar a função f aos filtered elementos


-- Lista em compreensão
-- [f x | x ← xs, p x]

-- Usando map e filter
map f (filter p xs)

-----------------------------------------

--3.2

dec2int :: [Int] -> Int
dec2int = foldl (\acc x -> acc * 10 + x) 0

-----------------------------------------

--3.3

zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith _ [] _ = []
zipWith _ _ [] = []
zipWith f (x:xs) (y:ys) = f x y : zipWith f xs ys

------------------------------------------

--3.4

isort :: Ord a => [a] -> [a]
isort = foldr insert []

------------------------------------------

--3.7
--(a)
(++) :: [a] -> [a] -> [a]
xs ++ ys = foldr (:) ys xs

--(b)
concat :: [[a]] -> [a]
concat = foldr (++) []

--(c)
reverse :: [a] -> [a]
reverse = foldr (\x acc -> acc ++ [x]) []

--(d)
reverse :: [a] -> [a]
reverse = foldl (flip (:)) []

--(e)
elem :: Eq a => a -> [a] -> Bool
elem x = any (== x)


-------------------------------------

--3.8
--(a)
palavras :: String -> [String]
palavras [] = []
palavras s = let (w, rest) = break (== ' ') (dropWhile (== ' ') s)
             in w : palavras (dropWhile (== ' ') rest)


--(b)
despalavras :: [String] -> String
despalavras = foldr1 (\w s -> w ++ " " ++ s)


-- -- Gonçalo Leão

