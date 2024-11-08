-- 1
maxpos :: [Int] -> Int
maxpos [] = 0
maxpos [x] = x
maxpos (x:xs)
    | x > maxpos (xs) = x
    | otherwise = maxpos xs


--2

dups :: [a] -> [a] 
dups [] = []
dups [x] = [x,x]
dups (x:y:xs) = x:x:y:(dups xs)



-- 3

transforma :: String -> String
transforma [] = []
transforma (x:xs) 
    | (x=='a' || x=='e' || x=='i' || x=='o' || x=='u') = x:'p':x:(transforma xs)
    | otherwise = x:(transforma xs)


-------------------------
type Vector = [Int]
type Matriz = [[Int]]
-------------------------

-- 4

transposta :: Matriz -> Matriz
transposta [] = []
transposta ([]:_) = []
transposta matriz = map head matriz : transposta (map tail matriz)


-- 5

prodInterno :: Vector -> Vector -> Int
prodInterno [] [] = 0
prodInterno (x:xs) (y:ys) = x*y + prodInterno xs ys



----------- 2023-----------

type Species = (String, Int)
type Zoo = [Species]

-- 1
isEndangered :: Species -> Bool
isEndangered spc = if (snd spc > 100) then False else True

-- 2
updateSpecies :: Species -> Int -> Species
updateSpecies spc n = (fst spc,snd spc + n) 

-- 3

filterSpecies :: Zoo -> (Species -> Bool) -> Zoo
filterSpecies [] _ = []
filterSpecies (x:xs) f 
    | f x == True = x:filterSpecies xs f
    | otherwise = filterSpecies xs f


-- 4

countAnimals :: Zoo -> Int
countAnimals [] = 0
countAnimals zoo = sum(map snd zoo)

-- 5

substring :: (Integral a) => String -> a -> a -> String
substring str i f = take (fromIntegral (f - i)) (drop (fromIntegral i) str)

takeinitial :: (Integral a) => String -> a -> String
takeinitial str n = take (fromIntegral n) str

takefinal :: (Integral a) => String -> a -> String
takefinal str n = take (fromIntegral n) (reverse str)

-- 6
hasSubstr :: String -> String -> Bool
hasSubstr [] _ = False
hasSubstr s1 s2
    | length  ([(x,y) | (x,y) <- zip s1 s2, x == y]) == length s2 = True
    | otherwise = hasSubstr (tail s1) s2

    
-- 7

sortSpeciesWithSubstr :: Zoo -> String -> (Zoo,Zoo)
sortSpeciesWithSubstr zoo s = ([spec | spec<-zoo, (hasSubstr (fst spec) s)], [spec | spec<-zoo, not (hasSubstr (fst spec) s)])

-- 8

rabbits :: (Integral a) => [a]
rabbits = [2,3] ++ [x+y | (x,y) <- zip rabbits (tail rabbits)]

-- 9

rabbitYears :: (Integral a) => a -> Int
rabbitYears n = length[ x | x <- take (fromIntegral n) rabbits, x<n]

-- 10

dendroWidth :: Dendrogram -> Int
dendroWidth (Leaf str) = 0
dendroWidth (Node esq n dir) = 2*n + (dendroEsq esq) + (dendroDir dir)

dendroEsq :: Dendrogram -> Int
dendroEsq (Leaf str) = 0
dendroEsq (Node esq n dir) = n + dendroEsq esq

dendroDir :: Dendrogram -> Int
dendroDir (Leaf str) = 0
dendroDir (Node esq n dir) = n + dendroDir dir


-- 11

dendroInBounds :: Dendrogram -> Int -> [String]
