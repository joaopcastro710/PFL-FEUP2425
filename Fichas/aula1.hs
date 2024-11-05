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