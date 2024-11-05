-- 1.1

testaTriangulo :: Float -> Float -> Float -> Bool
testaTriangulo a b c  
                        | ((a+b>c) && (a+c>b) && (b+c>a)) = True
                        | otherwise = False

-- 1.2
areaTriangulo :: Float -> Float -> Float -> Float
areaTriangulo a b c = sqrt (s*(s-a)*(s-b)*(s-c))
                    where s = ((a+b+c)/2)

-- 1.3

metades :: [a] -> ([a], [a])
metades b = (take mid b, drop mid b)
            where mid = length b `div` 2


-- 1.4
newLast :: [Int] -> Int
newLast xs = head a
             where a = reverse xs


newLastnew :: [Int] -> [Int]
newLastnew a = drop 1 b 
                where b = reverse a



-- 1.7
{-
(a) List[char] ou simplesmente [char]
(b) tuplo (char, char, char)
(c) lista[(Bool, Char)]
(d) tuplo([bool], [char])
(e) lista[(List->List)]
(f) List[(a -> a), (Bool -> Bool)]
-}

-- 1.8 - indique o tipo mais geral para as seguintes definções 
{-
(a) head retorna o 1º elemento e tail retorna a lista sem o primeiro elemento -> segundo :: [a] -> a ----> [a] é uma lista de elementos do tipo a, e a função retorna um elemento do tipo a.
(b) trocar :: (a, b) -> (b, a) ---> a função aceita um tuplo (a,b) e retorna outro tuplo (b,a)
(c) par :: a -> b -> (a, b) ---> aceita dois valores de tipos possivelmente diferentes e retorna um tuplo com ambos
(d) dobro :: Num a => a -> a ---> A função recebe um valor de um tipo numérico (Num a =>) e retorna outro valor do mesmo tipo.
(e) metade :: Fractional a => a -> a ---> A função recebe um valor de um tipo fracionário (Fractional a =>) e retorna outro valor do mesmo tipo.
(f) minuscula :: Char -> Bool ---> A função recebe um caractere e retorna um valor booleano.
(g) intervalo :: Ord a => a -> a -> a -> Bool ---> A função recebe três valores do mesmo tipo que suportam a comparação (Ord a =>) e retorna um booleano.
(h) palindromo :: Eq a => [a] -> Bool ---> A função recebe uma lista de elementos que suportam a comparação (Eq a =>) e retorna um booleano.
(i) twice :: (a -> a) -> a -> a ---> A função f é aplicada duas vezes, então f deve ser do tipo a -> a.
-}

-- 1.12 xor-> ou-exclusivo

xor :: Bool -> Bool -> Bool
xor True  False = True              --se o primeiro argumento é True e o segundo é False
xor False True  = True              -- se o 1º é falso e o segundo True 
xor _     _     = False             -- com _ _ onde amos são iguais, ou seja, true true ,...